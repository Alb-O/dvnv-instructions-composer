{ pkgs, config, lib, ... }:

let
  cfg = config.developerInstructions;
  developerInstructionsText = lib.concatStringsSep "\n\n" cfg.fragments;
  outputDir = if cfg.outputDir == null then "" else cfg.outputDir;
  hasOutputDir = outputDir != "";
  configTomlPath = if hasOutputDir then "${outputDir}/config.toml" else "config.toml";
  materializedFiles =
    {
      "${configTomlPath}".text = lib.concatStringsSep "\n" [
        "developer_instructions = '''"
        developerInstructionsText
        "'''"
        ""
      ];
    }
    // lib.optionalAttrs (
      hasOutputDir
      && cfg.generateNestedGitignore != null
      && cfg.generateNestedGitignore != ""
    ) {
      "${outputDir}/.gitignore".text = cfg.generateNestedGitignore;
    };
in
{
  options.developerInstructions = {
    fragments = lib.mkOption {
      type = with lib.types; listOf str;
      default = [];
      description = "Instruction text fragments merged from upstream to downstream repos.";
    };

    materializeToCodexConfig = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Whether to create .codex/config.toml with developer_instructions.";
    };

    outputDir = lib.mkOption {
      type = with lib.types; nullOr str;
      default = ".codex";
      description = "Output directory for config.toml. Set empty for repo root.";
    };

    generateNestedGitignore = lib.mkOption {
      type = with lib.types; nullOr str;
      default = "*";
      description = "Contents for <outputDir>/.gitignore. Set empty to disable generation.";
    };
  };

  config = {
    files = lib.mkIf cfg.materializeToCodexConfig materializedFiles;

    outputs.developer_instructions = pkgs.writeText "developer-instructions.md" developerInstructionsText;

    enterTest = ''
      set -euo pipefail
      test -f "${config.outputs.developer_instructions}"
    '';
  };
}
