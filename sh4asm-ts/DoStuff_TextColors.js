const fontColors = {
  '0x09': 'Red',
  '0x0b': 'Gold Gradient',
  '0x0c': 'Dark Blue Gradient',
  '0x0d': 'Lime Green Gradient',
  '0x0e': 'Light Gray Gradient*',
  '0x0f': 'Pink Gradient*',
  '0x10': 'Gray Gradient',
  '0x11': 'Cyan-Blue Gradient*',
  '0x12': 'Light Gray Gradient',
  '0x13': 'Green Gradient',
  '0x14': 'Lime Green Gradient*',
  '0x15': 'Blue Gradient',
  '0x17': 'Violet',
  '0x18': 'Aqua Blue',
  '0x19': 'Yellow Gradient',
  '0x1a': 'Yellow Orange Gradient',
  '0x1b': 'Salmon Gradient',
  '0x1c': 'Redish Magenta Gradient',
  '0x1d': 'White',
  '0x1e': 'Pink Red*',
  '0x1f': 'White*',
  '0x20': 'Pink Red',
  '0x21': 'Cyan',
  '0x22': 'Golden Yellow',
  '0x23': 'Bright Orange',
  '0x24': 'ArtyClick Red',
  '0x25': 'Bright Neon Pink',
  '0x26': 'Bright Lavender',
  '0x27': 'Periwinkle',
  '0x28': 'Washed Out Green',
  '0x29': 'Light Greenish Blue',
  '0x2a': 'Pale Turquoise',
  '0x2b': 'Baby Blue',
  '0x2c': 'Periwinkle Blue',
  '0x2d': 'Light Purple',
  '0x2e': 'Neon Pink',
  '0x2f': 'Razzle Dazzle Rose',
  '0x30': 'Dark Neon Pink',
  '0x31': 'Radical Red',
  '0x32': 'Orange Peel',
  '0x33': 'Rubber Ducky Yellow',
  '0x34': 'White/Yellow Gradient',
  '0x35': 'White/Red Gradient',
  '0x36': 'White/Purple Gradient',
  '0x37': 'White/Cyan Gradient',
  '0x38': 'Ochre',
}

let textColorsString = '';

const usefontColors = Object.entries(fontColors).map(([key, value]) => {
  textColorsString += `"${value}": {
    "prefix": "textcolor.${value}",
    "body": "${key} ; text ${value}"
  },\n`
}).join(',\n');

console.log(textColorsString);