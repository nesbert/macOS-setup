# SSH Keys

This guide covers both the default single-key setup and the optional
multi-host setup for Git hosting over SSH.

Use this with:

- [README.md](../README.md) for the default single-account bootstrap flow
- [multiple-git-accounts.md](multiple-git-accounts.md) when you also need per-repo Git identity routing

## Simple Setup

If you only use one GitHub account on the machine, use a single SSH key.
That is the default and is all most people need (same flow as in
`README.md`).

Generate a key:

```sh
ssh-keygen -t ed25519 -C "you@example.com"
```

This typically creates:

- `~/.ssh/id_ed25519`
- `~/.ssh/id_ed25519.pub`

Add the public key to GitHub:

```sh
pbcopy < ~/.ssh/id_ed25519.pub
```

Then verify the connection:

```sh
ssh -T git@github.com
```

For a single account, you usually do not need multi-host aliases.

If you also only use one Git identity, stop here and follow the simple Git
identity commands in [multiple-git-accounts.md](multiple-git-accounts.md).

## Multi-Host Setup (Only When Needed)

Only use this setup when you need multiple SSH keys for different accounts or
environments (for example, personal and work).

If you only need one key, stop at the Simple Setup above.

When multiple keys are required, use separate keys and SSH host aliases.

Typical setup:

1. Generate or copy one key per account.
2. Add each public key to the matching Git hosting account.
3. Define SSH host aliases that point at the correct private keys.
4. Use those aliases in Git remotes.
5. Keep machine-specific host aliases and key names in an ignored local config when using dotfiles.

Example SSH config:

```sshconfig
Host github-personal
  HostName github.com
  User git
  IdentityFile ~/.ssh/id_ed25519_personal

Host github-work
  HostName github.com
  User git
  IdentityFile ~/.ssh/id_ed25519_work
```

Example clone URLs:

```sh
git clone git@github-personal:your-user/your-repo.git
git clone git@github-work:your-company/your-repo.git
```

Verify each account:

```sh
ssh -T git@github-personal
ssh -T git@github-work
```

If you use the companion `macOS-dotfiles` repo, the clean pattern is to keep
machine-specific SSH settings in an ignored local file such as
`~/.ssh/config.local` and load it from your main SSH config.

When using multiple accounts, pair this SSH setup with
[multiple-git-accounts.md](multiple-git-accounts.md) so both transport (SSH
key) and commit identity (name/email/signing) are routed correctly.
