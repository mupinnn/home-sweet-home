(_final: prev: {
  vimPlugins = prev.vimPlugins // {
    nvim-lspconfig = prev.vimPlugins.nvim-lspconfig.overrideAttrs (oldAttrs: {
      patches = (oldAttrs.patches or [ ]) ++ [
        ./patches/fixes-nvim-lspconfig-astro-ls.patch
        ./patches/fixes-nvim-lspconfig-volar.patch
        # ./nvim-lspconfig-astro-ls.patch

        # (prev.fetchpatch {
        #   url =
        #     "https://patch-diff.githubusercontent.com/raw/neovim/nvim-lspconfig/pull/3585.patch";
        #   hash = "sha256-Uajoywv2LB9A0FWxmW5cDOWIn3Z68ahTBj3NgF8goq4=";
        # })
      ];
      # src = prev.fetchFromGitHub {
      #   owner = "neovim";
      #   repo = "nvim-lspconfig";
      #   rev = "14b5a806c928390fac9ff4a5630d20eb902afad8";
      #   sha256 = "0azb8qc6pg8j59jrh1ywplii11y0qlbls4x16zmawx2ngqipr7vg";
      # };
      #
      # patches = (oldAttrs.patches or [ ])
      #   ++ [ ./nvim-lspconfig-astro-ls.patch ];
    });
  };
  # nvim-lspconfig = prev.nvim-lspconfig.overrideAttrs
  #   (_: { patches = [ ./nvim-lspconfig-astro-ls.patch ]; });
})
