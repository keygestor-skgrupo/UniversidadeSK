<template>
	<div class="sk-logo-container" :class="containerClass">
		<!-- Logo wrapper with PNG image -->
		<div class="sk-logo-wrapper" :style="logoStyle">
			<img
				:src="logoUrl"
				alt="Universidade SK"
				class="sk-logo-image"
				:width="size"
				:height="size"
			/>
		</div>

		<!-- Text (optional) -->
		<div v-if="showText" class="sk-logo-text" :class="textClass">
			<span class="sk-logo-title">{{ title }}</span>
			<span v-if="subtitle" class="sk-logo-subtitle">{{ subtitle }}</span>
		</div>
	</div>
</template>

<script setup>
import { computed } from 'vue'
import skLogoPng from '/images/sk-logo.png'

const props = defineProps({
	size: {
		type: [Number, String],
		default: 40
	},
	showText: {
		type: Boolean,
		default: false
	},
	title: {
		type: String,
		default: 'Universidade SK'
	},
	subtitle: {
		type: String,
		default: ''
	},
	variant: {
		type: String,
		default: 'default' // 'default', 'light', 'dark', 'minimal'
	},
	orientation: {
		type: String,
		default: 'horizontal' // 'horizontal', 'vertical'
	}
})

const containerClass = computed(() => {
	return [
		`sk-logo--${props.variant}`,
		`sk-logo--${props.orientation}`
	]
})

const logoStyle = computed(() => ({
	width: `${props.size}px`,
	height: `${props.size}px`
}))

const textClass = computed(() => ({
	'ml-3': props.orientation === 'horizontal',
	'mt-2 text-center': props.orientation === 'vertical'
}))

const logoUrl = computed(() => skLogoPng)
</script>

<style scoped>
.sk-logo-container {
	display: flex;
	align-items: center;
}

.sk-logo--vertical {
	flex-direction: column;
}

.sk-logo-wrapper {
	display: flex;
	align-items: center;
	justify-content: center;
	flex-shrink: 0;
	transition: transform 0.3s ease;
}

.sk-logo-wrapper:hover {
	transform: scale(1.05);
}

.sk-logo-image {
	width: 100%;
	height: 100%;
	object-fit: contain;
}

.sk-logo-text {
	display: flex;
	flex-direction: column;
}

.sk-logo-title {
	font-weight: 600;
	font-size: 1rem;
	color: var(--text-primary, #1B365D);
	line-height: 1.2;
}

.sk-logo-subtitle {
	font-size: 0.75rem;
	color: var(--text-secondary, #64748B);
	margin-top: 2px;
}

/* Variants */
.sk-logo--dark .sk-logo-title {
	color: #F1F5F9;
}

.sk-logo--dark .sk-logo-subtitle {
	color: #94A3B8;
}

/* Animation on load */
@keyframes logoFadeIn {
	from {
		opacity: 0;
		transform: scale(0.8);
	}
	to {
		opacity: 1;
		transform: scale(1);
	}
}

.sk-logo-wrapper {
	animation: logoFadeIn 0.4s ease-out;
}
</style>
