const originalNames = [
    'Ryu', 'Zangief', 'Guile', 'Morrigan', 'Anakaris', 'Strider Hiryu', 'Cyclops', 'Wolverine', 'Psylocke', 'Iceman', 'Rogue', 'CaptainAmerica', 'Spider-Man', 'Hulk', 'Venom', 'Doctor Doom', 'Tron Bonne', 'Jill', 'Hayato', 'Ruby Heart', 'Sonson', 'Amingo', 'Marrow', 'Cable', 'Abyss-A', 'Abyss-B', 'Abyss-C', 'Chun-Li', 'Megaman', 'Roll', 'Akuma', 'B.B. Hood', 'Felicia', 'Charlie', 'Sakura', 'Dan', 'Cammy', 'Dhalsim', 'M.Bison', 'Ken', 'Gambit', 'Juggernaut', 'Storm', 'Sabretooth', 'Magneto', 'Shuma-Gorath', 'War Machine', 'Silver Samurai', 'Omega Red', 'Spiral', 'Colossus', 'Iron Man', 'Sentinel', 'Blackheart', 'Thanos', 'Jin', 'Captain Commando', 'Wolverine-B', 'Servbot'
];
const aNames = [
    'A.Ryu', 'A.Zangief', 'A.Guile', 'A.Morrigan', 'A.Anakaris', 'A.Strider Hiryu', 'A.Cyclops', 'A.Wolverine', 'A.Psylocke', 'A.Iceman', 'A.Rogue', 'A.Captain America', 'A.Spider-Man', 'A.Hulk', 'A.Venom', 'A.Doctor Doom', 'A.Tron Bonne', 'A.Jill', 'A.Hayato', 'A.Ruby Heart', 'A.Sonson', 'A.Amingo', 'A.Marrow', 'A.Cable', 'A.Abyss-A', 'A.Abyss-B', 'A.Abyss-C', 'A.Chun-Li', 'A.Megaman', 'A.Roll', 'A.Akuma', 'A.B.B. Hood', 'A.Felicia', 'A.Charlie', 'A.Sakura', 'A.Dan', 'A.Cammy', 'A.Dhalsim', 'A.M.Bison', 'A.Ken', 'A.Gambit', 'A.Juggernaut', 'A.Storm', 'A.Sabretooth', 'A.Magneto', 'A.Shuma-Gorath', 'A.War Machine', 'A.Silver Samurai', 'A.Omega Red', 'A.Spiral', 'A.Colossus', 'A.Iron Man', 'A.Sentinel', 'A.Blackheart', 'A.Thanos', 'A.Jin', 'A.Captain Commando', 'A.Wolverine-B', 'A.Servbot'
];
const bNames = [
    'B.Ryu', 'B.Zangief', 'B.Guile', 'B.Morrigan', 'B.Anakaris', 'B.Strider Hiryu', 'B.Cyclops', 'B.Wolverine', 'B.Psylocke', 'B.Iceman', 'B.Rogue', 'B.Captain America', 'B.Spider-Man', 'B.Hulk', 'B.Venom', 'B.Doctor Doom', 'B.Tron Bonne', 'B.Jill', 'B.Hayato', 'B.Ruby Heart', 'B.Sonson', 'B.Amingo', 'B.Marrow', 'B.Cable', 'B.Abyss-A', 'B.Abyss-B', 'B.Abyss-C', 'B.Chun-Li', 'B.Megaman', 'B.Roll', 'B.Akuma', 'B.B.B. Hood', 'B.Felicia', 'B.Charlie', 'B.Sakura', 'B.Dan', 'B.Cammy', 'B.Dhalsim', 'B.M.Bison', 'B.Ken', 'B.Gambit', 'B.Juggernaut', 'B.Storm', 'B.Sabretooth', 'B.Magneto', 'B.Shuma-Gorath', 'B.War Machine', 'B.Silver Samurai', 'B.Omega Red', 'B.Spiral', 'B.Colossus', 'B.Iron Man', 'B.Sentinel', 'B.Blackheart', 'B.Thanos', 'B.Jin', 'B.Captain Commando', 'B.Wolverine-B', 'B.Servbot'
];
const cNames = [
    'C.Ryu', 'C.Zangief', 'C.Guile', 'C.Morrigan', 'C.Anakaris', 'C.Strider Hiryu', 'C.Cyclops', 'C.Wolverine', 'C.Psylocke', 'C.Iceman', 'C.Rogue', 'C.Captain America', 'C.Spider-Man', 'C.Hulk', 'C.Venom', 'C.Doctor Doom', 'C.Tron Bonne', 'C.Jill', 'C.Hayato', 'C.Ruby Heart', 'C.Sonson', 'C.Amingo', 'C.Marrow', 'C.Cable', 'C.Abyss-A', 'C.Abyss-B', 'C.Abyss-C', 'C.Chun-Li', 'C.Megaman', 'C.Roll', 'C.Akuma', 'C.B.B. Hood', 'C.Felicia', 'C.Charlie', 'C.Sakura', 'C.Dan', 'C.Cammy', 'C.Dhalsim', 'C.M.Bison', 'C.Ken', 'C.Gambit', 'C.Juggernaut', 'C.Storm', 'C.Sabretooth', 'C.Magneto', 'C.Shuma-Gorath', 'C.War Machine', 'C.Silver Samurai', 'C.Omega Red', 'C.Spiral', 'C.Colossus', 'C.Iron Man', 'C.Sentinel', 'C.Blackheart', 'C.Thanos', 'C.Jin', 'C.Captain Commando', 'C.Wolverine-B', 'C.Servbot'
];

const aAddresses = [
    '0x00', '0x01', '0x02', '0x03', '0x04', '0x05', '0x06', '0x07', '0x08', '0x09', '0x0a', '0x0b', '0x0c', '0x0d', '0x0e', '0x0f', '0x10', '0x11', '0x12', '0x13', '0x14', '0x15', '0x16', '0x17', '0x18', '0x19', '0x1a', '0x1b', '0x1c', '0x1d', '0x1e', '0x1f', '0x20', '0x21', '0x22', '0x23', '0x24', '0x25', '0x26', '0x27', '0x28', '0x29', '0x2a', '0x2b', '0x2c', '0x2d', '0x2e', '0x2f', '0x30', '0x31', '0x32', '0x33', '0x34', '0x35', '0x36', '0x37', '0x38', '0x39', '0x3a',
];
const bAddresses = [
    '0x40', '0x41', '0x42', '0x43', '0x44', '0x45', '0x46', '0x47', '0x48', '0x49', '0x4a', '0x4b', '0x4c', '0x4d', '0x4e', '0x4f', '0x50', '0x51', '0x52', '0x53', '0x54', '0x55', '0x56', '0x57', '0x58', '0x59', '0x5a', '0x5b', '0x5c', '0x5d', '0x5e', '0x5f', '0x60', '0x61', '0x62', '0x63', '0x64', '0x65', '0x66', '0x67', '0x68', '0x69', '0x6a', '0x6b', '0x6c', '0x6d', '0x6e', '0x6f', '0x70', '0x71', '0x72', '0x73', '0x74', '0x75', '0x76', '0x77', '0x78', '0x79', '0x7a'
];
const cAddresses = [
    '0x80', '0x81', '0x82', '0x83', '0x84', '0x85', '0x86', '0x87', '0x88', '0x89', '0x8a', '0x8b', '0x8c', '0x8d', '0x8e', '0x8f', '0x90', '0x91', '0x92', '0x93', '0x94', '0x95', '0x96', '0x97', '0x98', '0x99', '0x9a', '0x9b', '0x9c', '0x9d', '0x9e', '0x9f', '0xa0', '0xa1', '0xa2', '0xa3', '0xa4', '0xa5', '0xa6', '0xa7', '0xa8', '0xa9', '0xaa', '0xab', '0xac', '0xad', '0xae', '0xaf', '0xb0', '0xb1', '0xb2', '0xb3', '0xb4', '0xb5', '0xb6', '0xb7', '0xb8', '0xb9', '0xba'
];

// Make 0x addresses🌟
const assistA = [];
const assistB = [];
const assistC = [];
aAddresses.forEach((address) => {
    let base = parseInt(address, 16)
    let aB = '';
    let aC = '';
    aB = (base + 64).toString(16);
    aC = (base + 128).toString(16);
    assistA.push(address)
    assistB.push('0x' + aB)
    assistC.push('0x' + aC)
});
console.log('A-Addresses: ' + assistA);
console.log('B-Addresses: ' + assistB);
console.log('C-Addresses: ' + assistC);

// Make names arrays 🌟
const namesA = []
const namesB = []
const namesC = []
originalNames.forEach((name) => {
    namesA.push('A.' + name);
    namesB.push('B.' + name);
    namesC.push('C.' + name);
});
console.log('A-Names: ' + namesA);
console.log('B-Names: ' + namesB);
console.log('C-Names: ' + namesC);

// Make Final Snippets🌟
let resultA = '';
let resultB = '';
let resultC = '';

for (let i = 0; i < originalNames.length; i++) {
    resultA +=
        `
"${aNames[i]}": {\r
    "prefix": "${aNames[i]}",\r
    "body": "${aAddresses[i]} ; ${aNames[i]} α"\r
},\r`
    resultB += `
"${bNames[i]}": {\r
    "prefix": "${bNames[i]}",\r
    "body": "${bAddresses[i]} ; ${bNames[i]} β"\r
},\r`
    resultC += `
"${cNames[i]}": {\r
    "prefix": "${cNames[i]}",\r
    "body": "${cAddresses[i]} ; ${cNames[i]} γ"\r
},\r`
}
console.log(resultA);
console.log(resultB);
console.log(resultC);