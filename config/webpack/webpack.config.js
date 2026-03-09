const path = require("path");
const { generateWebpackConfig, merge } = require('shakapacker');
const webpack = require("webpack");
const webpackConfig = generateWebpackConfig();
const sourcePath = path.resolve(__dirname, "../../app/javascript");
const nodeModulesPath = path.resolve(__dirname, "../../node_modules");

webpackConfig.module.rules.forEach((rule) => {
  if (!Array.isArray(rule.use)) return;

  rule.use.forEach((loader) => {
    if (typeof loader === "string" || !loader.loader?.includes("sass-loader")) return;

    const includePaths = loader.options?.sassOptions?.includePaths || [];
    const loadPaths = loader.options?.sassOptions?.loadPaths || [];
    const sassPaths = Array.from(
      new Set([...includePaths, ...loadPaths, sourcePath, nodeModulesPath]),
    );

    loader.options = loader.options || {};
    loader.options.sassOptions = loader.options.sassOptions || {};
    loader.options.sassOptions.includePaths = sassPaths;
    loader.options.sassOptions.loadPaths = sassPaths;
  });
});

// See the shakacode/shakapacker README and docs directory for advice on customizing your webpackConfig.
const customConfig = {
  plugins: [
    new webpack.ProvidePlugin({
      $: "jquery",
      jQuery: "jquery",
    }),
  ],
  resolve: {
    alias: {
      homeland: path.join(sourcePath, "homeland"),
      vendor: path.join(sourcePath, "vendor"),
    },
    extensions: [".js", ".ts", ".tsx", ".js.erb", ".css", ".scss"],
  },
}

module.exports = merge(webpackConfig, customConfig)
