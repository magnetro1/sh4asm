const originalNames = [
    'Ryu', 'Zangief', 'Guile', 'Morrigan', 'Anakaris', 'Strider Hiryu', 'Cyclops', 'Wolverine', 'Psylocke', 'Iceman', 'Rogue', 'CaptainAmerica', 'Spider-Man', 'Hulk', 'Venom', 'Doctor Doom', 'Tron Bonne', 'Jill', 'Hayato', 'Ruby Heart', 'Sonson', 'Amingo', 'Marrow', 'Cable', 'Abyss-A', 'Abyss-B', 'Abyss-C', 'Chun-Li', 'Megaman', 'Roll', 'Akuma', 'B.B. Hood', 'Felicia', 'Charlie', 'Sakura', 'Dan', 'Cammy', 'Dhalsim', 'M.Bison', 'Ken', 'Gambit', 'Juggernaut', 'Storm', 'Sabretooth', 'Magneto', 'Shuma-Gorath', 'War Machine', 'Silver Samurai', 'Omega Red', 'Spiral', 'Colossus', 'Iron Man', 'Sentinel', 'Blackheart', 'Thanos', 'Jin', 'Captain Commando', 'Wolverine-B', 'Servbot'
];
const aNames = [
    'a.Ryu','a.Zangief','a.Guile','a.Morrigan','a.Anakaris','a.Strider Hiryu','a.Cyclops','a.Wolverine','a.Psylocke','a.Iceman','a.Rogue','a.CaptainAmerica','a.Spider-Man','a.Hulk','a.Venom','a.Doctor Doom','a.Tron Bonne','a.Jill','a.Hayato','a.Ruby Heart','a.Sonson','a.Amingo','a.Marrow','a.Cable','a.Abyss-A','a.Abyss-B','a.Abyss-C','a.Chun-Li','a.Megaman','a.Roll','a.Akuma','a.B.B. Hood','a.Felicia','a.Charlie','a.Sakura','a.Dan','a.Cammy','a.Dhalsim','a.M.Bison','a.Ken','a.Gambit','a.Juggernaut','a.Storm','a.Sabretooth','a.Magneto','a.Shuma-Gorath','a.War Machine','a.Silver Samurai','a.Omega Red','a.Spiral','a.Colossus','a.Iron Man','a.Sentinel','a.Blackheart','a.Thanos','a.Jin','a.Captain Commando','a.Wolverine-B','a.Servbot'
];
const bNames = [
    'b.Ryu','b.Zangief','b.Guile','b.Morrigan','b.Anakaris','b.Strider Hiryu','b.Cyclops','b.Wolverine','b.Psylocke','b.Iceman','b.Rogue','b.CaptainAmerica','b.Spider-Man','b.Hulk','b.Venom','b.Doctor Doom','b.Tron Bonne','b.Jill','b.Hayato','b.Ruby Heart','b.Sonson','b.Amingo','b.Marrow','b.Cable','b.Abyss-A','b.Abyss-B','b.Abyss-C','b.Chun-Li','b.Megaman','b.Roll','b.Akuma','b.B.B. Hood','b.Felicia','b.Charlie','b.Sakura','b.Dan','b.Cammy','b.Dhalsim','b.M.Bison','b.Ken','b.Gambit','b.Juggernaut','b.Storm','b.Sabretooth','b.Magneto','b.Shuma-Gorath','b.War Machine','b.Silver Samurai','b.Omega Red','b.Spiral','b.Colossus','b.Iron Man','b.Sentinel','b.Blackheart','b.Thanos','b.Jin','b.Captain Commando','b.Wolverine-B','b.Servbot'
];
const cNames = [
    'y.Ryu','y.Zangief','y.Guile','y.Morrigan','y.Anakaris','y.Strider Hiryu','y.Cyclops','y.Wolverine','y.Psylocke','y.Iceman','y.Rogue','y.CaptainAmerica','y.Spider-Man','y.Hulk','y.Venom','y.Doctor Doom','y.Tron Bonne','y.Jill','y.Hayato','y.Ruby Heart','y.Sonson','y.Amingo','y.Marrow','y.Cable','y.Abyss-A','y.Abyss-B','y.Abyss-C','y.Chun-Li','y.Megaman','y.Roll','y.Akuma','y.B.B. Hood','y.Felicia','y.Charlie','y.Sakura','y.Dan','y.Cammy','y.Dhalsim','y.M.Bison','y.Ken','y.Gambit','y.Juggernaut','y.Storm','y.Sabretooth','y.Magneto','y.Shuma-Gorath','y.War Machine','y.Silver Samurai','y.Omega Red','y.Spiral','y.Colossus','y.Iron Man','y.Sentinel','y.Blackheart','y.Thanos','y.Jin','y.Captain Commando','y.Wolverine-B','y.Servbot'
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
    namesA.push('\'a.' + name + '\'');
    namesB.push('\'b.' + name + '\'');
    namesC.push('\'y.' + name + '\'');
});
console.log('A-Names: ' + namesA);
console.log('B-Names: ' + namesB);
console.log('Y-Names: ' + namesC);

// Make Final Snippets🌟
let resultA = '';
let resultB = '';
let resultC = '';

for (let i = 0; i < originalNames.length; i++) {
    resultA +=
        `
"${aNames[i]}": {\r
    "prefix": "${aNames[i]}",\r
    "body": "${aAddresses[i]} ; ${originalNames[i]} α"\r
},\r`
    resultB += `
"${bNames[i]}": {\r
    "prefix": "${bNames[i]}",\r
    "body": "${bAddresses[i]} ; ${originalNames[i]} β"\r
},\r`
    resultC += `
"${cNames[i]}": {\r
    "prefix": "${cNames[i]}",\r
    "body": "${cAddresses[i]} ; ${originalNames[i]} γ"\r
},\r`
}
console.log(resultA);
console.log(resultB);
console.log(resultC);