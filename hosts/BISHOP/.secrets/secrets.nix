let
  # TODO: Replace with actual keys
  # Host key: ssh-keyscan localhost or cat /etc/ssh/ssh_host_ed25519_key.pub
  bishop = "ssh-ed25519 PLACEHOLDER_BISHOP_HOST_KEY";
  # User key: cat ~/.ssh/id_ed25519.pub (or id_ed25519_sk.pub)
  user = "ssh-ed25519 PLACEHOLDER_USER_KEY";
in
{
  "rbw-email.age".publicKeys = [ bishop user ];
  "rbw-base-url.age".publicKeys = [ bishop user ];
}
