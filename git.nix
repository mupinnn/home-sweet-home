let
  me = {
    name = "Ahmad Muwaffaq";
    email = "itsmupin@gmail.com";
    core = { sshCommand = "ssh -i ~/.ssh/id_ed25519-personal"; };
  };
  wjm = {
    name = "Ahmad Muwaffaq";
    email = "afaqih@juraganmaterial.id";
    core = { sshCommand = "ssh -i ~/.ssh/id_ed25519-jm"; };
  };
in {
  programs.git = {
    enable = true;
    extraConfig = {
      init = { defaultBranch = "main"; };
      core = { editor = "nano"; };
      pull = { ff = "only"; };
      push = { autoSetupRemote = true; };
      url = { "git@github.com:" = { insteadOf = "https://github.com/"; }; };
      diff.tool = "vimdiff";
      difftool.prompt = false;
    };
    includes = [
      {
        condition = "gitdir:~/work/personal/";
        contents.user = me;
      }

      {
        condition = "gitdir:~/learn/";
        contents.user = me;
      }

      {
        condition = "gitdir:~/sandbox/";
        contents.user = me;
      }

      {
        condition = "gitdir:~/.config/home-manager/";
        contents.user = me;
      }

      {
        condition = "gitdir:~/work/juraganmaterial.id/";
        contents.user = wjm;
      }

      {
        condition = "gitdir:~/work/24dev/";
        contents.user = me;
      }

      {
        condition = "gitdir:~/work/fap/";
        contents.user = me;
      }
    ];
  };

  programs.gh = {
    enable = true;
    settings.git_protocol = "ssh";
  };
}
