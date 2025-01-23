{ pkgs, ... }:

{
  programs.nixvim = {
    enable = true;
    vimAlias = true;
    viAlias = true;
    defaultEditor = true;

    extraPackages = with pkgs; [
      nixfmt-classic
      # nodePackages.typescript
      # nodePackages.typescript-language-server
    ];

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

    filetype = { extension = { "mdx" = "markdown.mdx"; }; };

    colorschemes.kanagawa.enable = true;

    keymaps = [
      {
        action = ":NvimTreeToggle<cr>";
        key = "<C-h>";
        mode = [ "n" ];
        options = {
          silent = true;
          noremap = true;
        };
      }

      {
        action = ":NvimTreeOpen<cr>";
        key = "<C-b>";
        mode = [ "n" ];
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
            lualine_b = [ "branch" { icon = null; } ];
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
        hijackDirectories = {
          enable = true;
          autoOpen = true;
        };
      };

      comment.enable = true;
      indent-blankline.enable = true;
      nvim-autopairs.enable = true;
      gitsigns.enable = true;
      colorizer.enable = true;

      treesitter = {
        enable = true;
        settings = {
          highlight.enable = true;
          indent.enable = true;
          autotag.enable = true;
        };
        grammarPackages =
          builtins.map (x: pkgs.vimPlugins.nvim-treesitter.builtGrammars.${x}) [
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

      telescope = {
        enable = true;
        extensions = {
          fzf-native.enable = true;
          fzf-native.settings = {
            fuzzy = true;
            override_generic_sorter = true;
            override_file_sorter = true;
            case_mode = "smart_case";

          };
        };
        settings = {
          pickers = {
            find_files = {
              find_command =
                [ "rg" "--files" "--hidden" "--glob" "!**/.git/*" ];
            };
          };
        };
        keymaps = {
          ff.options.desc = "Find by files";
          ff.action = "find_files";

          fg.options.desc = "Find by text";
          fg.action = "live_grep";

          fb.options.desc = "Find by current buffers";
          fb.action = "buffers";

          fh.options.desc = "Find by help tags";
          fh.action = "help_tags";

          gR.options.desc = "Show LSP references";
          gR.action = "lsp_references";

          gd.options.desc = "Show LSP definitions";
          gd.action = "lsp_definitions";

          gi.options.desc = "Show LSP implementations";
          gi.action = "lsp_implementations";

          gt.options.desc = "Show LSP type definitions";
          gt.action = "lsp_type_definitions";
        };
      };

      cmp_luasnip.enable = true;
      cmp-nvim-lsp.enable = true;
      cmp-path.enable = true;
      cmp-buffer.enable = true;
      luasnip.enable = true;
      luasnip.fromVscode = [ { } ];
      friendly-snippets.enable = true;
      cmp = {
        enable = true;
        autoEnableSources = false;
        settings = {
          sources = [
            { name = "nvim_lsp"; }
            { name = "luasnip"; }
            { name = "buffer"; }
            { name = "path"; }
          ];
          snippet.expand = ''
            function(args)
              require('luasnip').lsp_expand(args.body)
            end
          '';
          mapping = {
            "<C-k>" = "cmp.mapping.select_prev_item()";
            "<C-j>" = "cmp.mapping.select_next_item()";
            "<C-b>" = "cmp.mapping.scroll_docs(-4)";
            "<C-f>" = "cmp.mapping.scroll_docs(4)";
            "<C-Space>" = "cmp.mapping(cmp.mapping.complete(), { 'i', 'c' })";
            "<C-y>" = "cmp.config.disable";
            "<C-e>" =
              "cmp.mapping({ i = cmp.mapping.abort(), c = cmp.mapping.close() })";
            "<CR>" = "cmp.mapping.confirm({ select = true })";
            "<S-Tab>" =
              "cmp.mapping(cmp.mapping.select_prev_item(), {'i', 's'})";
            "<Tab>" = "cmp.mapping(cmp.mapping.select_next_item(), {'i', 's'})";
          };
        };
      };

      lsp = {
        enable = true;
        servers = {
          astro.enable = true;
          bashls.enable = true;
          ccls.enable = true;
          cssls.enable = true;
          emmet_ls.enable = true;
          eslint.enable = true;
          html.enable = true;
          jsonls.enable = true;
          lua_ls.enable = true;
          nixd.enable = true;
          nixd.settings = { formatting.command = [ "nixfmt" ]; };
          tailwindcss.enable = true;
          ts_ls.enable = true;
          volar.enable = true;
        };
      };
    };
  };
}
