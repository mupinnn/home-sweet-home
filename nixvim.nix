{ pkgs, ... }:

{
  programs.nixvim = {
    enable = true;
    vimAlias = true;
    viAlias = true;
    defaultEditor = true;

		opts = {
			title = true;
			number = true;
			relativenumber = true;
			shiftwidth = 2;
			syntax = "on";
			expandtab = true;
			softtabstop = 2;
			autoindent = true;
			smartindent = true;
			showmode = false;
		};

		filetype = {
			extension = {
				"mdx" = "markdown.mdx";
			};
		};

    colorschemes.kanagawa.enable = true;

    keymaps = [
      {
      	action = ":NvimTreeToggle<cr>";
	key = "<C-h>";
	mode = ["n"];
	options = {
	  silent = true;
	  noremap = true;
	};
      }

      {
      	action = ":NvimTreeOpen<cr>";
	key = "<C-b>";
	mode = ["n"];
	options = {
	  silent = true;
	  noremap = true;
	};
      }
    ];

    plugins = {
      lualine = {
        enable = true;
        settings = {
          options = {
            icons_enabled = true;
            theme = "papercolor_dark";
            always_divide_middle = true;
            globalstatus = true;
            refresh = {
              statusline = 1000;
              tabline = 1000;
              winbar = 1000;
            };
          };
          sections = {
            lualine_a = [ "mode" ];
            lualine_b = [
              "branch"
              { icon = null; }
            ];
            lualine_c = [ "filename" ];
            lualine_x = [ "filetype" "encoding" "fileformat" ];
            lualine_y = [ "progress" ];
            lualine_z = [ "location" ];
          };
        };
      };

      web-devicons.enable = true;

      nvim-tree = {
      	enable = true;
	disableNetrw = true;
	git = { ignore = false; };
      };

      comment.enable = true;
      indent-blankline.enable = true;
      nvim-autopairs.enable = true;
      gitsigns.enable = true;
      colorizer.enable = true;

      ts-autotag = {
      	enable = true;
	settings = {
					opts = {
enable_close = true;
	  enable_rename = true;
	  enable_close_on_slash = true;

					};
	  	};
      };

      treesitter = {
      	enable = true;
	settings = {
	  highlight.enable = true;
	  indent.enable = true;
	  autotag.enable = true;
	};
	grammarPackages = builtins.map (x: pkgs.vimPlugins.nvim-treesitter.builtGrammars.${x})[
	  "astro"
	  "bash"
	  "c"
	  "cmake"
	  "comment"
	  "cpp"
	  "css"
	  "diff"
	  "dot"
	  "git_config"
	  "git_rebase"
	  "gitattributes"
	  "gitcommit"
	  "gitignore"
	  "graphql"
	  "html"
	  "javascript"
	  "jsdoc"
	  "json"
	  "lua"
	  "luadoc"
	  "make"
	  "markdown"
	  "nix"
	  "php"
	  "scss"
	  "sql"
	  "tmux"
	  "toml"
	  "tsx"
	  "typescript"
	  "vim"
	  "vimdoc"
	  "vue"
	  "xml"
	  "yaml"
	];
      };
    };
  };
}
