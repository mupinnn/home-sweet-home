{ pkgs, ... }:

let
  ft_using_prettier = [
    "astro"
    "blade"
    "css"
    "html"
    "javascript"
    "javascriptreact"
    "json"
    "markdown"
    "markdown.mdx"
    "sass"
    "scss"
    "twig"
    "typescript"
    "typescriptreact"
    "vue"
    "yaml"
  ];
  conform_prettier_sets = builtins.listToAttrs (map (lang: {
    name = lang;
    value = [ "prettier" ];
  }) ft_using_prettier);

  treesitter-blade-grammar = pkgs.tree-sitter.buildGrammar {
    language = "blade";
    version = "bcdc4b0";
    src = pkgs.fetchFromGitHub {
      owner = "EmranMR";
      repo = "tree-sitter-blade";
      rev = "bcdc4b01827cac21205f7453e9be02f906943128";
      hash = "sha256-Svco/cweC311fUlKi34sh0AWfP/VYRWJMXyAuUVRhAw=";
    };
  };
in {
  programs.nixvim = {
    enable = true;
    vimAlias = true;
    viAlias = true;
    defaultEditor = true;

    extraPackages = with pkgs; [
      nixfmt-classic
      stylua
      nodePackages.prettier
      # nodePackages.typescript
      # nodePackages.typescript-language-server
    ];

    extraPlugins = with pkgs.vimPlugins; [ lsp-progress-nvim ];

    extraConfigLuaPre = ''
      local lsp_progress = require("lsp-progress");
      lsp_progress.setup()
    '';

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
      wrap = false;
    };

    filetype = {
      extension = {
        "mdx" = "markdown.mdx";
        "blade.php" = "blade";
      };
    };

    colorschemes.kanagawa.enable = true;

    clipboard.register = "unnamed";

    globals = {
      loaded_netrw = 1;
      loaded_netrwPlugin = 1;
    };

    autoCmd = [{
      event = [ "User" ];
      pattern = "LspProgressStatusUpdated";
      callback.__raw = ''
        function()
          require("lualine").refresh()
        end
      '';
    }];

    userCommands = {
      FormatDisable = {
        bang = true;
        desc = "Disable autoformat-on-save";
        command.__raw = ''
          function(args)
            if args.bang then
              vim.b.disable_autoformat = true
            else
              vim.g.disable_autoformat = true
            end
          end
        '';
      };

      FormatEnable = {
        desc = "Disable autoformat-on-save";
        command.__raw = ''
          function()
            vim.b.disable_autoformat = false
            vim.g.disable_autoformat = false
          end
        '';
      };

    };

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

      {
        action.__raw = ''
          function()
            require("conform").format({ lsp_fallback = true, async = false, timeout_ms = 1000 })
          end
        '';
        key = "<leader>f";
        mode = [ "n" "v" ];
        options = { desc = "Format file or range (in visual mode)"; };
      }

      {
        action.__raw = ''
          function()
            if vim.b.disable_autoformat then
              vim.cmd "FormatEnable"
              vim.notify "Enabled autoformat for current buffer"
            else
              vim.cmd "FormatDisable!"
              vim.notify " Disabled autoformat for current buffer"
            end
          end
        '';
        key = "<leader>tf";
        mode = [ "n" ];
        options = { desc = "Toggle autoformat for current buffer"; };
      }

      {
        action.__raw = ''
          function()
            if vim.g.disable_autoformat then
              vim.cmd "FormatEnable"
              vim.notify "Enabled autoformat globally"
            else
              vim.cmd "FormatDisable"
              vim.notify " Disabled autoformat globally"
            end
          end
        '';
        key = "<leader>tF";
        mode = [ "n" ];
        options = { desc = "Toggle autoformat globally"; };
      }
    ];

    plugins = {
      lualine = {
        enable = true;
        settings = {
          options = {
            globalstatus = true;
            component_separators = "";
            section_separators = {
              left = "";
              right = "";
            };
          };
          sections = {
            lualine_a = [ "mode" ];
            lualine_b = [{
              __unkeyed-1 = "filename";
              file_status = true;
              newfile_status = true;
              path = 4;
            }];
            lualine_c = [ "branch" ];
            lualine_x = [
              {
                __unkeyed-1 = "diff";
                source.__raw = ''
                  function()
                    local gitsigns = vim.b.gitsigns_status_dict
                    if (gitsigns) then
                      return {
                        added = gitsigns.added,
                        modified = gitsigns.changed,
                        removed = gitsigns.removed
                      }
                    end
                  end
                '';
                symbols = {
                  added = " ";
                  modified = " ";
                  removed = " ";
                };
              }

              {
                __unkeyed-1 = "diagnostics";
                sections = [ "error" "warn" "info" "hint" ];
                symbols = {
                  error = " ";
                  warn = " ";
                  info = " ";
                  hint = " ";
                };
              }

              {
                __unkeyed-1.__raw = ''
                  function()
                    return lsp_progress.progress({
                      max_size = 50,
                      format = function(client_messages)
                        local sign = "[  LSP]"
                        if #client_messages > 0 then
                          return sign .. " " .. table.concat(client_messages, " ")
                        end

                        local clients = vim.lsp.get_active_clients({ bufnr = 0 })
                        if (next(clients) == nil) then
                          return "No LSP"
                        end

                        local client_names = {}
                        for _, client in pairs(clients) do
                          table.insert(client_names, client.name)
                        end

                        return sign .. " " .. table.concat(client_names, ", ")
                      end
                    })
                  end
                '';
              }
            ];
            lualine_y = [
              {
                __unkeyed-1 = "filetype";
                icon_only = true;
              }
              "progress"
            ];
            lualine_z = [ "location" ];
          };
          inactive_winbar = {
            lualine_a = [ "filename" ];
            lualine_b = [ "location" ];
            lualine_c = [ "" ];
            lualine_x = [ "" ];
            lualine_y = [ "" ];
            lualine_z = [ "" ];
          };
        };
      };

      web-devicons.enable = true;

      nvim-tree = {
        enable = true;
        disableNetrw = false;
        hijackNetrw = true;
        hijackCursor = true;
        respectBufCwd = false;
        syncRootWithCwd = true;

        git.ignore = false;
        filters.dotfiles = false;
        view.width = 25;
      };

      comment.enable = true;

      indent-blankline.enable = true;
      indent-blankline.settings.exclude.filetypes = [ "dashboard" ];

      nvim-autopairs.enable = true;
      gitsigns.enable = true;
      colorizer.enable = true;

      treesitter = {
        enable = true;
        settings = {
          highlight.enable = true;
          indent.enable = true;
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
            "dart"
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
            "twig"
            "typescript"
            "vim"
            "vimdoc"
            "vue"
            "xml"
            "yaml"
          ] ++ [ treesitter-blade-grammar ];
        luaConfig.post = ''
          do
            local parser_config = require("nvim-treesitter.parsers").get_parser_configs()
            parser_config.blade = {
              install_info = {
                url = "''${treesitter-blade-grammar}",
                files = {"src/parser.c"}
              },
              filetype = "blade"
            }
          end
        '';
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
          live-grep-args.enable = true;
          fzf-native.enable = true;
          fzf-native.settings = {
            fuzzy = true;
            override_generic_sorter = true;
            override_file_sorter = true;
            case_mode = "smart_case";
          };
        };
        settings = {
          defaults = { file_ignore_patterns = [ "node_modules" "vendor" ]; };
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
        package = pkgs.vimPlugins.nvim-lspconfig;
        servers = {
          astro.enable = true;
          bashls.enable = true;
          ccls.enable = true;
          cssls.enable = true;
          dartls.enable = true;
          emmet_ls.enable = true;
          eslint.enable = true;
          html.enable = true;
          intelephense.enable = true;
          intelephense.package = pkgs.intelephense;
          jsonls.enable = true;
          lua_ls.enable = true;
          nixd.enable = true;
          nixd.settings = { formatting.command = [ "nixfmt" ]; };
          # phpactor.enable = true;
          # phpactor.extraOptions = {
          #   init_options = { "language_server_php_cs_fixer.enabled" = true; };
          # };
          tailwindcss.enable = true;
          tailwindcss.extraOptions = {
            settings = {
              tailwindCSS = {
                experimental = {
                  classRegex =
                    # [ ''(["'`][^"'`]*.*?["'`])'' ''["'`]([^"'`]*).*?["'`]'' ];
                    # [ "tv\\(([^)]*)\\)" ''["'`]?([^"'`]+)["'`]?'' ];
                    [ "(`.*?`)" ''(".*?")'' "('.*?')" ];
                };
              };
            };
          };
          ts_ls.enable = true;
          volar.enable = true;
        };
        capabilities = ''
          local capabilities = vim.lsp.protocol.make_client_capabilities()
          capabilities.textDocument.completion.completionItem.snippetSupport = true

          require("lspconfig").cssls.setup {
            capabilities = capabilities
          }
        '';
      };

      conform-nvim = {
        enable = true;
        settings = {
          format_on_save.__raw = ''
            function(bufnr)
              if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
                return
              end

              return {
                lsp_fallback = true,
                async = false,
                timeout_ms = 1000
              }
            end
          '';
          formatters_by_ft = {
            lua = [ "stylua" ];
            nix = [ "nixfmt" ];
            php = [ "php_cs_fixer" ];
            dart = [ "dart_format" ];
            "_" = [ "trim_whitespace" ];
          } // conform_prettier_sets;
        };
      };

      dashboard.enable = true;
      dashboard.settings.config = {
        shortcut = [{
          icon = "[  Github]";
          desc = "@mupinnn";
        }];
        header = [
          "⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿"
          "⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿"
          "⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⢟⠟⣛⢫⠹⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿"
          "⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⢏⠎⠄⢅⠑⡱⡹⡌⡎⣏⢿⣻⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿"
          "⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⣟⡯⡯⠢⢐⠠⠑⠐⠨⠠⠑⡈⠌⡾⡽⡽⡽⣽⢽⣺⢽⡽⣞⣯⢿⡿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿"
          "⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⢿⡻⣵⣫⢷⢝⠎⡐⠄⠂⠈⠄⠂⠐⠄⡂⣕⢯⢯⢯⢯⣗⣯⢯⡯⣯⣗⣯⢯⡿⣽⣻⢿⣿⣿⣿⣿⣿⣿⣿"
          "⣿⣿⣿⣿⣿⣿⢿⣻⢝⣮⣻⡺⣵⡳⡽⣝⢦⢔⢬⢄⢥⡢⡢⣕⢼⣜⣮⡯⣿⣽⣻⡾⣽⢯⣟⣷⣻⣾⣻⣽⢷⣟⣯⣷⢿⣻⣿⣿⣿⣿"
          "⣿⣿⣿⣻⡽⡾⣽⣺⣽⣞⣾⡽⣾⢽⣽⢾⡯⣿⢯⡿⣽⢯⣟⣯⣿⣳⣯⡿⣷⢯⣷⢿⣻⣯⢿⡽⣗⣯⡿⣾⣻⣽⣻⣾⣻⣯⢿⣿⣿⣿"
          "⣿⣿⢾⣾⣻⣟⣯⣿⢾⣯⡷⣟⣿⢯⣟⣯⡿⣯⣟⣯⣿⣻⣽⢷⣯⢷⢿⡽⣯⢿⣽⣻⢽⣞⢿⢽⢯⣗⣟⢽⡳⡯⣗⣿⣺⣽⣻⣞⣿⣿"
          "⣿⣿⣻⣽⣯⣿⣽⡾⣟⣷⢿⣻⡽⡿⡽⣗⡿⡽⣞⣗⣟⣞⡾⣽⣺⢽⣫⢟⣞⣗⢷⣝⣗⡽⡽⡵⣳⣳⡳⣽⡺⣝⣞⢞⣽⢾⣽⢾⣻⣿"
          "⣿⣯⢿⢽⣺⣳⣳⣻⢽⣺⢯⢯⢯⢿⣝⣗⡯⣯⣗⢷⣳⣳⣻⣺⡺⣽⣺⢽⣺⢮⣗⣗⢷⢽⣝⣞⣗⢷⢽⣺⡺⣵⡳⣫⢯⡿⣞⣿⣻⣿"
          "⣿⣿⢽⢽⣺⢵⣻⣺⢽⣺⢽⢯⣟⣗⣗⣯⣻⣺⣺⢽⣺⣺⡺⣮⣻⡺⣮⣻⣺⣳⣳⢽⢽⢵⣳⡳⣳⣫⢗⡷⣽⣪⢯⣳⢯⢿⡽⣞⣿⣿"
          "⣿⣿⢯⣟⡾⡽⣞⡾⣽⣺⢽⡽⣺⣺⣞⣞⡾⡵⣯⣻⣺⣺⣝⣞⣮⣟⣞⣞⣾⣺⢾⣽⡽⣗⣷⣟⣷⢿⣽⣯⡷⣟⣯⡿⣽⢿⡽⣯⢿⣿"
          "⣿⣿⣻⢮⢯⡯⡷⡯⣗⣯⢯⣯⣟⣾⢾⣺⣽⣯⣷⢷⣷⡷⣿⢾⡷⣿⣽⣯⣿⣽⢿⣳⣿⣟⣯⣿⢾⣟⣷⣯⢿⣯⡷⣿⣻⣽⣻⣽⢿⣿"
          "⣿⣿⣯⣿⣟⣿⢿⡿⣟⣿⣻⣽⣯⡿⣟⣿⣽⣾⣟⣿⢷⡿⣟⣿⣻⡿⣾⢷⡿⣾⢿⣻⡷⣿⣽⡾⣿⣽⢾⣽⣻⣞⣯⣟⡷⣯⣷⣻⣿⣿"
          "⣿⣿⣿⣽⣯⣿⢿⣻⣿⣻⣿⣽⣷⢿⡿⣯⡿⣾⣻⡾⣟⣿⣻⣽⣯⢿⣽⢿⡽⣟⣿⣽⣻⡷⣯⣿⣳⣟⣯⣯⡷⣟⣷⣻⡽⣷⣻⣞⣿⣿"
          "⣿⣿⣿⣯⣿⣾⣿⣟⣯⣿⡾⣷⣟⣿⣻⣯⡿⣯⡿⣽⢿⣽⣻⣾⡽⣿⡽⣟⣟⣯⢷⣻⣳⣻⢽⣺⡳⡯⣳⣳⡫⣗⢗⡵⣟⣷⣳⢯⣿⣿"
          "⣿⣿⣿⣷⢿⡷⣿⣽⣟⣷⡿⣯⣿⡽⣟⣾⣻⢯⣟⡯⡿⣝⣗⣗⢯⢗⡯⣻⡺⡺⣝⢞⢮⢮⡳⡳⣝⢮⡳⡵⣝⢮⢳⢽⣳⣻⣺⣿⣿⣿"
          "⣿⣿⣿⣻⣻⡻⡯⣗⢿⢽⢽⣝⢮⢯⣳⡳⡽⣕⣗⢽⢝⢮⡺⡼⣝⢵⡫⣞⣞⣝⢮⣫⡳⡳⣝⢝⢮⡳⣝⢞⡎⣗⢝⣽⣺⣗⡷⣿⣿⣿"
          "⣿⣿⣿⣞⢮⢯⢯⡫⡯⣳⡳⡽⣹⢕⢷⢝⣝⢮⢮⣫⣫⡳⡽⢵⢝⣕⢯⡺⡲⣕⡳⡕⡵⡝⡎⣏⢧⢫⣎⣧⣳⣱⣧⣷⣷⣷⣿⣿⣿⣿"
          "⣿⣿⣿⡺⡽⣕⢯⢞⡽⣺⢪⢯⡺⡹⣕⢯⢎⡗⡗⣕⢮⢺⢪⢳⢣⡳⣕⣝⣜⣦⣧⣷⣷⣷⣿⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿"
          "⣿⣿⣿⢽⣹⢪⢏⡗⣝⢎⢗⢵⢹⡩⣎⣮⣧⣧⣯⣮⣾⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿"
          "⣿⣿⣿⣷⣷⣯⣷⣿⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿"
        ];
      };

      wakatime.enable = true;
    };
  };
}
