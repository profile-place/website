module.exports = {
	plugins: [
		require('@csstools/postcss-sass')({
			includePaths: ['./node_modules']
		}),
		//require('autoprefixer'),
		require('tailwindcss'),
		require('cssnano')
	]
};
