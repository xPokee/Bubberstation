import {
  CheckboxInput,
  type Feature,
  FeatureShortTextInput,
  type FeatureToggle,
} from '../../base';

export const has_custom_tongue: FeatureToggle = {
  name: 'Custom Tongue',
  description:
    'Allows you to customise what your say modifiers are, previously done via "X Traits" quirks.',
  component: CheckboxInput,
};

export const custom_tongue_ask: Feature<string> = {
  name: 'Custom Tongue: Ask?',
  description: 'Automated Ask say modifier. A-Z Only, no spaces.',
  component: FeatureShortTextInput,
};

export const custom_tongue_exclaim: Feature<string> = {
  name: 'Custom Tongue: Exclaim!',
  description: 'Automated Exclaim say modifier. A-Z Only, no spaces.',
  component: FeatureShortTextInput,
};

export const custom_tongue_whisper: Feature<string> = {
  name: 'Custom Tongue: whisper',
  description: 'Automated Whisper say modifier. A-Z Only, no spaces.',
  component: FeatureShortTextInput,
};

export const custom_tongue_yell: Feature<string> = {
  name: 'Custom Tongue: Yell!!',
  description: 'Automated Yell say modifier. A-Z Only, no spaces.',
  component: FeatureShortTextInput,
};

export const custom_tongue_say: Feature<string> = {
  name: 'Custom Tongue: Say.',
  description: 'Automated Say say modifier. A-Z Only, no spaces.',
  component: FeatureShortTextInput,
};
