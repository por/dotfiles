figma.showUI(__html__, { width: 220, height: 48, themeColors: true });

const NODE_PROPS = [
  'id', 'name', 'type', 'visible', 'locked',
  'x', 'y', 'width', 'height', 'rotation', 'absoluteBoundingBox',
  'opacity', 'blendMode', 'isMask', 'clipsContent',
  'fills', 'strokes', 'strokeWeight', 'strokeTopWeight', 'strokeRightWeight', 'strokeBottomWeight', 'strokeLeftWeight',
  'strokeAlign', 'dashPattern', 'effects',
  'cornerRadius', 'topLeftRadius', 'topRightRadius', 'bottomRightRadius', 'bottomLeftRadius', 'cornerSmoothing',
  'fillStyleId', 'strokeStyleId', 'effectStyleId', 'textStyleId', 'gridStyleId',
  'constraints', 'layoutGrids',
  'layoutPositioning', 'layoutAlign', 'layoutGrow', 'layoutSizingHorizontal', 'layoutSizingVertical',
  'minWidth', 'maxWidth', 'minHeight', 'maxHeight',
  'layoutMode', 'layoutWrap', 'primaryAxisAlignItems', 'counterAxisAlignItems', 'counterAxisAlignContent',
  'primaryAxisSizingMode', 'counterAxisSizingMode', 'itemSpacing', 'counterAxisSpacing', 'itemReverseZIndex',
  'paddingTop', 'paddingRight', 'paddingBottom', 'paddingLeft',
  'gridRowCount', 'gridColumnCount', 'gridRowGap', 'gridColumnGap',
  'characters', 'fontName', 'fontSize', 'fontWeight', 'lineHeight', 'letterSpacing', 'paragraphSpacing',
  'textAlignHorizontal', 'textAlignVertical', 'textAutoResize', 'textCase', 'textDecoration', 'textTruncation', 'maxLines',
  'componentProperties', 'componentPropertyDefinitions', 'variantProperties',
  'boundVariables', 'description',
];

const AUTO_LAYOUT_PROPS = [
  'layoutWrap', 'primaryAxisAlignItems', 'counterAxisAlignItems', 'counterAxisAlignContent',
  'primaryAxisSizingMode', 'counterAxisSizingMode', 'itemSpacing', 'counterAxisSpacing', 'itemReverseZIndex',
  'paddingTop', 'paddingRight', 'paddingBottom', 'paddingLeft',
];

const GRID_PROPS = ['gridRowCount', 'gridColumnCount', 'gridRowGap', 'gridColumnGap'];
const STROKE_PROPS = [
  'strokeWeight', 'strokeTopWeight', 'strokeRightWeight', 'strokeBottomWeight', 'strokeLeftWeight', 'strokeAlign', 'dashPattern',
];
const CORNER_PROPS = ['topLeftRadius', 'topRightRadius', 'bottomRightRadius', 'bottomLeftRadius'];

const DEFAULTS = {
  visible: true, locked: false, rotation: 0, opacity: 1, isMask: false,
  blendMode: 'NORMAL', cornerRadius: 0, layoutMode: 'NONE', layoutPositioning: 'AUTO', layoutGrow: 0, layoutAlign: 'INHERIT',
  cornerSmoothing: 0, textDecoration: 'NONE', textCase: 'ORIGINAL', textTruncation: 'DISABLED', paragraphSpacing: 0,
};

const isDefault = (key, value) => DEFAULTS[key] === value || (key === 'blendMode' && value === 'PASS_THROUGH');

const TEXT_SEGMENT_PROPS = [
  'fontName', 'fontSize', 'fontWeight', 'lineHeight', 'letterSpacing', 'textCase', 'textDecoration', 'fills', 'textStyleId',
];

const STYLE_PROPS = [
  'id', 'name', 'type', 'description', 'paints', 'effects', 'layoutGrids',
  'fontName', 'fontSize', 'lineHeight', 'letterSpacing', 'paragraphSpacing', 'textCase', 'textDecoration', 'boundVariables',
];

async function variableName(id) {
  const variable = await figma.variables.getVariableByIdAsync(id);
  return variable ? variable.name : id;
}

async function styleName(id) {
  if (!id || id === figma.mixed) return id;
  const style = await figma.getStyleByIdAsync(id);
  return style ? style.name : id;
}

async function plain(value) {
  if (value === figma.mixed) return 'mixed';
  if (Array.isArray(value)) return Promise.all(value.map(plain));
  if (value && typeof value === 'object') {
    if (value.type === 'VARIABLE_ALIAS') return { variable: await variableName(value.id) };
    const out = {};
    for (const [key, item] of Object.entries(value)) {
      if (!isEmpty(item) && !isDefault(key, item)) out[key] = await plain(item);
    }
    return out;
  }
  return value;
}

function isEmpty(value) {
  return value == null || value === '' || (Array.isArray(value) && value.length === 0)
    || (typeof value === 'object' && !Array.isArray(value) && Object.keys(value).length === 0);
}

async function pick(source, keys) {
  const out = {};
  for (const key of keys) {
    if (!(key in source)) continue;
    let value;
    try {
      value = source[key];
    } catch {
      continue;
    }
    if (isEmpty(value) || isDefault(key, value)) continue;
    if (key.endsWith('StyleId')) value = await styleName(value);
    out[key] = await plain(value);
  }
  return out;
}

async function serialize(node, depth) {
  const out = await pick(node, NODE_PROPS);
  const drop = (keys) => keys.forEach((key) => delete out[key]);
  if (!out.layoutMode) drop(AUTO_LAYOUT_PROPS);
  if (out.layoutMode !== 'GRID') drop(GRID_PROPS);
  if (!out.strokes) drop(STROKE_PROPS);
  if (out.cornerRadius !== 'mixed') drop(CORNER_PROPS);

  if (node.type === 'TEXT' && TEXT_SEGMENT_PROPS.some((key) => node[key] === figma.mixed)) {
    out.segments = await plain(node.getStyledTextSegments(TEXT_SEGMENT_PROPS));
    for (const segment of out.segments) segment.textStyleId = await styleName(segment.textStyleId);
  }
  if (node.type === 'INSTANCE') {
    const main = await node.getMainComponentAsync();
    if (main) {
      out.mainComponent = { id: main.id, name: main.name };
      if (main.parent && main.parent.type === 'COMPONENT_SET') out.mainComponent.set = main.parent.name;
    }
  }
  if ('children' in node) {
    if (depth === 0) out.childCount = node.children.length;
    else out.children = await Promise.all(node.children.map((child) => serialize(child, depth - 1)));
  }
  return out;
}

async function targets(id) {
  if (id) {
    const node = await figma.getNodeByIdAsync(id);
    if (!node) throw new Error(`No node with id ${id}`);
    return [node];
  }
  return figma.currentPage.selection.length ? figma.currentPage.selection : [figma.currentPage];
}

const summary = (node) => ({ id: node.id, name: node.name, type: node.type });

const commands = {
  async info() {
    return {
      file: figma.root.name,
      currentPage: summary(figma.currentPage),
      pages: figma.root.children.map(summary),
      selection: figma.currentPage.selection.map(summary),
    };
  },

  async tree({ id, depth }) {
    const nodes = await targets(id);
    return Promise.all(nodes.map((node) => serialize(node, depth)));
  },

  async css({ id, deep = false }) {
    const out = [];
    for (const node of await targets(id)) {
      const nodes = deep && 'findAll' in node ? [node, ...node.findAll()] : [node];
      for (const each of nodes) {
        if ('getCSSAsync' in each) out.push({ ...summary(each), css: await each.getCSSAsync() });
      }
    }
    return out;
  },

  async export({ id, format = 'PNG', scale = 2 }) {
    const [node] = await targets(id);
    const settings = format === 'SVG' || format === 'PDF' ? { format } : { format, constraint: { type: 'SCALE', value: scale } };
    return { ...summary(node), format, base64: figma.base64Encode(await node.exportAsync(settings)) };
  },

  async find({ query = '', type }) {
    const needle = query.toLowerCase();
    return figma.root
      .findAll((node) => (!type || node.type === type) && node.name.toLowerCase().includes(needle))
      .map((node) => {
        let page = node;
        while (page.type !== 'PAGE') page = page.parent;
        return { ...summary(node), page: page.name };
      });
  },

  async variables() {
    const collections = await figma.variables.getLocalVariableCollectionsAsync();
    return Promise.all(collections.map(async (collection) => ({
      name: collection.name,
      modes: collection.modes.map((mode) => mode.name),
      variables: await Promise.all(collection.variableIds.map(async (variableId) => {
        const variable = await figma.variables.getVariableByIdAsync(variableId);
        const values = {};
        for (const mode of collection.modes) values[mode.name] = await plain(variable.valuesByMode[mode.modeId]);
        return {
          name: variable.name,
          type: variable.resolvedType,
          values,
          scopes: variable.scopes,
          codeSyntax: variable.codeSyntax,
          description: variable.description,
        };
      })),
    })));
  },

  async styles() {
    const [paint, text, effect, grid] = await Promise.all([
      figma.getLocalPaintStylesAsync(),
      figma.getLocalTextStylesAsync(),
      figma.getLocalEffectStylesAsync(),
      figma.getLocalGridStylesAsync(),
    ]);
    const all = async (styles) => Promise.all(styles.map((style) => pick(style, STYLE_PROPS)));
    return { paint: await all(paint), text: await all(text), effect: await all(effect), grid: await all(grid) };
  },

  async eval({ code }) {
    const run = new Function('figma', `return (async () => { ${code} })()`);
    return plain(await run(figma));
  },
};

figma.ui.onmessage = async ({ reqId, cmd, args = {} }) => {
  try {
    if (!commands[cmd]) throw new Error(`Unknown command ${cmd}`);
    await figma.loadAllPagesAsync();
    figma.ui.postMessage({ reqId, ok: true, data: await commands[cmd](args) });
  } catch (error) {
    figma.ui.postMessage({ reqId, ok: false, error: String((error && error.stack) || error) });
  }
};
