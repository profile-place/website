module.exports = {
	purge: [
		// sad i dont think we can do this with eex
		// TODO: possibly make this work with .eex files?
		//yeah there is no way this will work with eex

		// this basically concats all ununsed css variables
		// and purges them in production in any file in this block
	],
	theme: {
		extend: {
			colors: {
				darken: '#1E1E1E',
				darkish: '#2B2B2B'
			}
		}
	},
	variants: {},
	plugins: []
};
