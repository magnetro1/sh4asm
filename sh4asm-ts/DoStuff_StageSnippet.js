const stages_Hex_2_Names = {
  '0x00': 'Boat2/Airship - Fog/Day',
  '0x01': 'Desert1/Desert - Sunset',
  '0x02': 'Factory/Dock',
  '0x03': 'Carnival1/Carnival - Day',
  '0x04': 'Bridge1/Swamp - Gray',
  '0x05': 'Cave2/Cave - Water',
  '0x06': 'Clock1/Clock - Winter',
  '0x07': 'Raft2/Raft - Ice',
  '0x08': 'Abyss/Form 1',
  '0x09': 'Boat1/Airship - Night',

  '0x0a': 'Desert2/Desert - Day',
  '0x0b': 'Training',
  '0x0c': 'Carnival2/Carnival - Night',
  '0x0d': 'Bridge2/Swamp - Pink',
  '0x0e': 'Cave1/Cave - Lava',
  '0x0f': 'Clock2/Clock - Spring',

  '0x10': 'Raft1/Raft - Water',
};

let stageString = '';
// Generate a snippet using the values as the prefix and the keys as the body of the snippet.
const stages_Hex_2_Snippet = Object.entries(stages_Hex_2_Names).map(([key, value]) => {
  stageString += `"${value}": {
    "prefix": "stage.${value}",
    "body": "${key} ; stage ${value}"
  },\n`
}).join(',\n');

console.log(stageString);