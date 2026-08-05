# Multiple Git Accounts

This project does not validate Git identity during install.

This guide is for Git identity routing (name, email, signing).
For SSH transport and key selection, see [ssh-keys.md](ssh-keys.md).

Use this with:

- [README.md](../README.md) for the default first-time setup order
- [ssh-keys.md](ssh-keys.md) if you need multiple SSH keys and host aliases

If you only use one Git identity on a machine, keep it simple:

```sh
git config --global user.name "Your Name"
git config --global user.email "you@example.com"
```

You can verify the active values with:

```sh
git config --global --get user.name
git config --global --get user.email
```

If you also use one GitHub account with one SSH key, you usually do not need
the multi-account pattern below.

If you use personal and work accounts on the same machine, the recommended
approach is to keep Git account routing in your dotfiles repo and keep
machine-specific values in ignored local files.

A practical multi-account pattern is:

1. Keep a shared base Git config in your dotfiles repo.
2. Use `includeIf` rules to select identity files by repository path.
3. Store the real `user.name`, `user.email`, and signing preferences in ignored
   local files such as `personal.local`, `work.local`, or `school.local`.
4. Adjust the `gitdir:` paths to match the directories you actually use on your
   machine.

Example routing config:

```gitconfig
[includeIf "gitdir:~/Code/github.com/your-user/"]
  path = ~/.config/git/personal.local

[includeIf "gitdir:~/Code/github.com/your-company/"]
  path = ~/.config/git/work.local
```

Example local identity file:

```gitconfig
[user]
  name = Your Name
  email = you@example.com
```

Example repository layout and behavior:

```txt
~/Code/github.com/your-user/personal-site
~/Code/github.com/your-user/macOS-dotfiles
~/Code/github.com/your-company/internal-api
~/Code/github.com/your-company/platform-web
```

With the `includeIf` rules above:

- repos under `~/Code/github.com/your-user/` use `~/.config/git/personal.local`
- repos under `~/Code/github.com/your-company/` use `~/.config/git/work.local`

Example checks inside each repository:

```sh
cd ~/Code/github.com/your-user/personal-site
git config --get user.email
# you@example.com

cd ~/Code/github.com/your-company/internal-api
git config --get user.email
# you@company.com
```

If you also use SSH host aliases, the matching remotes might look like:

```sh
git -C ~/Code/github.com/your-user/personal-site remote get-url origin
# git@github-personal:your-user/personal-site.git

git -C ~/Code/github.com/your-company/internal-api remote get-url origin
# git@github-work:your-company/internal-api.git
```

Useful checks:

```sh
git config --show-origin --get user.name
git config --show-origin --get user.email
git config --list --show-origin
```
