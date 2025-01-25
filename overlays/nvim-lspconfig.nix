(_final: prev: {
  # vimPlugins = prev.vimPlugins // {
  #   nvim-lspconfig = prev.vimPlugins.nvim-lspconfig.overrideAttrs (_: {
  #     patches = [ ./nvim-lspconfig-astro-ls.patch ];
  #     # src = prev.fetchFromGitHub {
  #     #   owner = "neovim";
  #     #   repo = "nvim-lspconfig";
  #     #   rev = "14b5a806c928390fac9ff4a5630d20eb902afad8";
  #     #   sha256 = "0azb8qc6pg8j59jrh1ywplii11y0qlbls4x16zmawx2ngqipr7vg";
  #     # };
  #     #
  #     # patches = (oldAttrs.patches or [ ])
  #     #   ++ [ ./nvim-lspconfig-astro-ls.patch ];
  #   });
  # };
  nvim-lspconfig = prev.nvim-lspconfig.overrideAttrs
    (_: { patches = [ ./nvim-lspconfig-astro-ls.patch ]; });
})
