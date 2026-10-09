#!/usr/bin/env node
import { writeFileSync } from 'node:fs';
import { createServer } from 'node:http';
import { parseArgs } from 'node:util';

const RELAY = 'http://localhost:7865';

const USAGE = `Usage: bridge.mjs <command> [node] [options]

  serve                         run the relay the Figma plugin connects to
  info                          file name, pages, current selection
  tree [node] [--depth N]       layer tree with layout, fills, text, variables
  css [node] [--deep]           Dev Mode CSS for the node (and descendants)
  export <node> [--format png|jpg|svg|pdf] [--scale 2] [--out file]
  find <text> [--type FRAME]    nodes whose name contains <text>, on every page
  variables                     local variable collections with values per mode
  styles                        local paint, text, effect and grid styles
  eval '<js>'                   run an async function body with \`figma\` in scope

[node] takes "244:12185", "244-12185" or a Figma URL with node-id. Without it,
tree and css use the current selection, or the current page.`;

function serve() {
  const queue = [];
  const pollers = [];
  const pending = new Map();
  let nextId = 1;
  let lastPoll = 0;

  const dispatch = () => {
    while (queue.length && pollers.length) send(pollers.shift(), 200, queue.shift());
  };

  const send = (res, status, body) => {
    res.writeHead(status, { 'Access-Control-Allow-Origin': '*', 'Content-Type': 'application/json' });
    res.end(body === undefined ? undefined : JSON.stringify(body));
  };

  const readBody = async (req) => {
    let body = '';
    for await (const chunk of req) body += chunk;
    return JSON.parse(body);
  };

  createServer(async (req, res) => {
    // The CLI sends no Origin and the plugin iframe sends "null"; anything else is a webpage.
    if (req.headers.origin !== undefined && req.headers.origin !== 'null') return send(res, 403);

    if (req.method === 'GET' && req.url === '/next') {
      lastPoll = Date.now();
      const timer = setTimeout(() => send(res, 204), 25_000);
      res.on('close', () => {
        clearTimeout(timer);
        if (pollers.includes(res)) pollers.splice(pollers.indexOf(res), 1);
      });
      pollers.push(res);
      return dispatch();
    }

    if (req.method === 'POST' && req.url === '/result') {
      const result = await readBody(req);
      pending.get(result.reqId)?.(result);
      pending.delete(result.reqId);
      return send(res, 204);
    }

    if (req.method === 'POST' && req.url === '/cmd') {
      if (Date.now() - lastPoll > 30_000) {
        return send(res, 503, { ok: false, error: 'Plugin not connected: run Figma Bridge in Figma desktop' });
      }
      const reqId = nextId++;
      const timer = setTimeout(() => {
        pending.delete(reqId);
        send(res, 504, { ok: false, error: 'Plugin did not answer within 120s' });
      }, 120_000);
      pending.set(reqId, (result) => {
        clearTimeout(timer);
        send(res, 200, result);
      });
      queue.push({ reqId, ...(await readBody(req)) });
      return dispatch();
    }

    send(res, 404);
  }).listen(7865, () => console.error(`Relay listening on ${RELAY}`));
}

function nodeId(input) {
  if (!input) return undefined;
  const fromUrl = input.match(/node-id=([^&]+)/);
  return decodeURIComponent(fromUrl ? fromUrl[1] : input).replaceAll('-', ':');
}

async function run(cmd, args) {
  let res;
  try {
    res = await fetch(`${RELAY}/cmd`, { method: 'POST', body: JSON.stringify({ cmd, args }) });
  } catch {
    throw new Error(`Relay not running: start it with \`node ${import.meta.filename} serve\``);
  }
  const result = await res.json();
  if (!result.ok) throw new Error(result.error);
  return result.data;
}

const { positionals, values } = parseArgs({
  allowPositionals: true,
  options: {
    depth: { type: 'string' },
    deep: { type: 'boolean' },
    format: { type: 'string', default: 'png' },
    scale: { type: 'string', default: '2' },
    out: { type: 'string' },
    type: { type: 'string' },
  },
});
const [cmd, arg] = positionals;

try {
  switch (cmd) {
    case 'serve':
      serve();
      break;
    case 'export': {
      const format = values.format.toUpperCase();
      const data = await run('export', { id: nodeId(arg), format, scale: Number(values.scale) });
      const out = values.out ?? `${data.id.replaceAll(':', '-')}.${format.toLowerCase()}`;
      writeFileSync(out, Buffer.from(data.base64, 'base64'));
      console.log(out);
      break;
    }
    case 'info':
    case 'variables':
    case 'styles':
    case 'tree':
    case 'css':
    case 'find':
    case 'eval': {
      const args = {
        tree: { id: nodeId(arg), depth: Number(values.depth ?? -1) },
        css: { id: nodeId(arg), deep: values.deep },
        find: { query: arg, type: values.type },
        eval: { code: arg },
      }[cmd];
      console.log(JSON.stringify(await run(cmd, args), null, 2));
      break;
    }
    default:
      console.error(USAGE);
      process.exitCode = cmd ? 1 : 0;
  }
} catch (error) {
  console.error(error.message);
  process.exitCode = 1;
}
