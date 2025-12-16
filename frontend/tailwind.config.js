import frappeUIPreset from 'frappe-ui/tailwind'

export default {
	presets: [frappeUIPreset],
	darkMode: ['class', '[data-theme="dark"]'],
	content: [
		'./index.html',
		'./src/**/*.{vue,js,ts,jsx,tsx}',
		'./node_modules/frappe-ui/src/**/*.{vue,js,ts,jsx,tsx}',
		'../node_modules/frappe-ui/src/**/*.{vue,js,ts,jsx,tsx}',
		'./node_modules/frappe-ui/frappe/**/*.{vue,js,ts,jsx,tsx}',
		'../node_modules/frappe-ui/frappe/**/*.{vue,js,ts,jsx,tsx}',
	],
	theme: {
		extend: {
			// Cores Universidade SK
			colors: {
				'sk-red': {
					50: '#FEF2F2',
					100: '#FEE2E2',
					200: '#FECACA',
					300: '#FCA5A5',
					400: '#F87171',
					500: '#E31837',
					600: '#DC2626',
					700: '#B91C1C',
					800: '#991B1B',
					900: '#7F1D1D',
					DEFAULT: '#E31837',
				},
				'sk-navy': {
					50: '#EFF6FF',
					100: '#DBEAFE',
					200: '#BFDBFE',
					300: '#93C5FD',
					400: '#60A5FA',
					500: '#1B365D',
					600: '#162D4F',
					700: '#112240',
					800: '#0C1832',
					900: '#070D1A',
					DEFAULT: '#1B365D',
				},
			},
			strokeWidth: {
				1.5: '1.5',
			},
			screens: {
				'2xl': '1600px',
				'3xl': '1920px',
			},
			fontFamily: {
				sans: ['Inter', 'system-ui', '-apple-system', 'sans-serif'],
			},
			borderRadius: {
				'xl': '12px',
				'2xl': '16px',
				'3xl': '24px',
			},
			boxShadow: {
				'sk': '0 4px 6px -1px rgba(27, 54, 93, 0.1), 0 2px 4px -2px rgba(27, 54, 93, 0.1)',
				'sk-lg': '0 10px 15px -3px rgba(27, 54, 93, 0.1), 0 4px 6px -4px rgba(27, 54, 93, 0.1)',
				'sk-glow': '0 0 20px rgba(227, 24, 55, 0.15)',
				'sk-glow-lg': '0 0 40px rgba(227, 24, 55, 0.2)',
			},
			animation: {
				'fade-in': 'fadeIn 0.4s ease-out forwards',
				'slide-up': 'slideUp 0.4s ease-out forwards',
				'slide-down': 'slideDown 0.4s ease-out forwards',
				'scale-in': 'scaleIn 0.3s ease-out forwards',
				'bounce-in': 'bounceIn 0.5s cubic-bezier(0.68, -0.55, 0.265, 1.55) forwards',
				'pulse-sk': 'pulseSK 2s ease-in-out infinite',
				'shimmer': 'shimmer 1.5s infinite',
			},
			keyframes: {
				fadeIn: {
					'0%': { opacity: '0', transform: 'translateY(10px)' },
					'100%': { opacity: '1', transform: 'translateY(0)' },
				},
				slideUp: {
					'0%': { opacity: '0', transform: 'translateY(20px)' },
					'100%': { opacity: '1', transform: 'translateY(0)' },
				},
				slideDown: {
					'0%': { opacity: '0', transform: 'translateY(-20px)' },
					'100%': { opacity: '1', transform: 'translateY(0)' },
				},
				scaleIn: {
					'0%': { opacity: '0', transform: 'scale(0.95)' },
					'100%': { opacity: '1', transform: 'scale(1)' },
				},
				bounceIn: {
					'0%': { opacity: '0', transform: 'scale(0.3)' },
					'50%': { transform: 'scale(1.05)' },
					'70%': { transform: 'scale(0.9)' },
					'100%': { opacity: '1', transform: 'scale(1)' },
				},
				pulseSK: {
					'0%, 100%': { transform: 'scale(1)' },
					'50%': { transform: 'scale(1.05)' },
				},
				shimmer: {
					'0%': { backgroundPosition: '-200% 0' },
					'100%': { backgroundPosition: '200% 0' },
				},
			},
			transitionTimingFunction: {
				'bounce-sk': 'cubic-bezier(0.68, -0.55, 0.265, 1.55)',
			},
		},
	},
	plugins: [],
}
