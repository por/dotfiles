# Pipe my public key to my clipboard.
# A pubkey alias already defined in a running shell would shadow this function.
unalias pubkey 2>/dev/null
pubkey () {
  local key
  for key in ~/.ssh/id_ed25519.pub ~/.ssh/id_ecdsa.pub ~/.ssh/id_rsa.pub; do
    if [[ -f $key ]]; then
      pbcopy < "$key" && echo "=> Public key $key copied to pasteboard."
      return
    fi
  done
  echo "pubkey: no public key found in ~/.ssh (id_ed25519, id_ecdsa, id_rsa)" >&2
  return 1
}
