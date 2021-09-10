let
  jupyterLib = builtins.fetchGit {
    url = https://github.com/tweag/jupyterWith;
    rev = "70f1dddd6446ab0155a5b0ff659153b397419a2d";
  };
  nixpkgsPath = jupyterLib + "/nix";
  haskellOverlay = import ./haskell-overlay.nix;
  pkgs = import nixpkgsPath {overlays = [ haskellOverlay ]; config={allowUnfree=true; allowBroken=true;};};

  jupyter = import jupyterLib {pkgs=pkgs;};

  iHaskell = jupyter.kernels.iHaskellWith {
      haskellPackages = pkgs.haskell.packages.ghc865;
      name = "monad-bayes";
      packages = p: with p; [
        monad-bayes
        hmatrix
        hvega
        statistics 
        vector
        ihaskell-hvega
        formatting
        foldl
        histogram-fill
      ];
    };

  jupyterEnvironment =
    jupyter.jupyterlabWith {
      kernels = [ iHaskell ];
    };
in
  jupyterEnvironment.env
