{
  programs.nixvim = {
    enable = true;
    vimAlias = true;
    viAlias = true;
    defaultEditor = true;

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
    };
  };
}
