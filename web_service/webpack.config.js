const path = require('path');

const SRC_DIR = path.resolve(__dirname, './');
const OUT_DIR = path.resolve(__dirname, 'build');

const config = {
	entry: {
		app: path.resolve(SRC_DIR, 'app.ts')
	},
	module: {
		rules: [
			{
				test: /\.tsx?$/,
				use: 'ts-loader',
				exclude: /node_modules/,
			},
		],
	},
	resolve: {
		extensions: ['.tsx', '.ts', '.js'],
	},
	output: {
		path: OUT_DIR,
		filename: '[name].js',
		library: '[name]',
		libraryTarget: 'umd'
	},
	target: 'node'
};

module.exports = config;
