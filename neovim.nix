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
          plugin = lualine-nvim;
          config = toLuaFile ./configs/nvim/lualine.lua;
        }

        nvim-web-devicons
        {
          plugin = nvim-tree-lua;
          config = toLuaFile ./configs/nvim/nvim-tree.lua;
        }

        {
          plugin = comment-nvim;
          config = toLua "require('Comment').setup()";
        }

        {
          plugin = indent-blankline-nvim;
          config = toLua "require('ibl').setup()";
        }

        {
          plugin = nvim-autopairs;
          config = toLua "require('nvim-autopairs').setup()";
        }

        {
          plugin = gitsigns-nvim;
          config = toLua "require('gitsigns').setup()";
        }

        {
          plugin = nvim-colorizer-lua;
          config = toLua "require('colorizer').setup()";
        }

        nvim-ts-autotag
        {
          plugin = (nvim-treesitter.withPlugins (p: [
            p.tree-sitter-nix
            p.tree-sitter-vim
            p.tree-sitter-vimdoc
            p.tree-sitter-bash
            p.tree-sitter-lua
            p.tree-sitter-json
            p.tree-sitter-css
            p.tree-sitter-html
            p.tree-sitter-javascript
            p.tree-sitter-markdown
            p.tree-sitter-scss
            p.tree-sitter-tsx
            p.tree-sitter-typescript
            p.tree-sitter-vue
            p.tree-sitter-yaml
          ]));
          config = toLuaFile ./configs/nvim/treesitter.lua;
        }

        {
          plugin = telescope-nvim;
          config = toLuaFile ./configs/nvim/telescope.lua;
        }
        telescope-fzf-native-nvim
        plenary-nvim

        neodev-nvim
        cmp_luasnip
        cmp-nvim-lsp
        luasnip
        friendly-snippets
        {
          plugin = nvim-cmp;
          config = toLuaFile ./configs/nvim/cmp.lua;
        }
        nvim-lspconfig
        mason-tool-installer-nvim
        {
          plugin = nvim-lint;
          config = toLuaFile ./configs/nvim/nvim-lint.lua;
        }
        {
          plugin = conform-nvim;
          config = toLuaFile ./configs/nvim/conform.lua;
        }
        {
          plugin = mason-nvim;
          config = toLuaFile ./configs/nvim/mason.lua;
        }
        {
          plugin = mason-lspconfig-nvim;
          config = toLuaFile ./configs/nvim/lsp.lua;
        }

        tokyonight-nvim
        kanagawa-nvim
      ];

      extraLuaConfig = ''
        	${builtins.readFile ./configs/nvim/options.lua}
            ${builtins.readFile ./configs/nvim/colorscheme.lua}
      '';
    };
}
