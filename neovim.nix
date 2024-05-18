{ pkgs, ... }:

{
  programs.neovim =
  let
  	toLua = str: "lua << EOF\n${str}\nEOF\n";
	toLuaFile = file: "lua << EOF\n${builtins.readFile file}\nEOF\n";
  in
  {
    enable = true;
    defaultEditor = true;
    vimAlias = true;
    viAlias = true;
    vimdiffAlias = true;
    
    plugins = with pkgs.vimPlugins; [
    	{
		plugin = comment-nvim;
		config = toLua "require(\"Comment\").setup()";
	}

	{
		plugin = gruvbox-nvim;
		config = "colorscheme gruvbox";
	}
    ];
  };
}
