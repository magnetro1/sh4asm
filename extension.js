const vscode = require('vscode');
const path = require('path');

const staticData = require('./sh4asm_staticData.js');

/**
 * @param {vscode.ExtensionContext} context
 */
function activate(context) {
	// Use the console to output diagnostic information (console.log) and errors (console.error)
	// This line of code will only be executed once when your extension is activated
	// console.log('Congratulations, your extension "sh4asm" is now active!');

	// The command has been defined in the package.json file
	// Now provide the implementation of the command with  registerCommand
	// The commandId parameter must match the command field in package.json
	let disposable = vscode.commands.registerCommand('sh4asm.helloWorld', function () {
		// The code you place here will be executed every time your command is executed

		// Display a message box to the user
		vscode.window.showInformationMessage('Hello World from sh4asm!');
	});


	/* 	

	Making a new Command here. The command will wrap the selected text
	in a box using the '-' character multiple times.
	this command is registered inside of the package.json file
	under the "commands" array.
	To use it, select some text, then press F1 or Ctrl+Shift+P
	and type "Box Selection" and press enter. 
	
	*/

	let box = vscode.commands.registerCommand('sh4asm.box', function () {
		// Get the active text editor
		let editor = vscode.window.activeTextEditor;
		if (editor) {
			// Get the document, then the selection, then the text
			let doc = editor.document;
			let selection = editor.selection;
			let txt = doc.getText(selection);
			// Surround the selected text with box characters
			let surroundChar = ';*************************************\n';
			let boxText = txt.split('\n').map(str => {
				return surroundChar + str + '\n' + surroundChar;
			}).join('');
			// Replace the selection with box text
			editor.edit(editBuilder => {
				editBuilder.replace(selection, boxText);
			});
		}
	});

	// Register the commands
	context.subscriptions.push(box);
	context.subscriptions.push(disposable);


	// const charThumbnailsPath = './supportMedia/characterThumbnails/';

	// Hover over a word to get a popup
	vscode.languages.registerHoverProvider('sh4asm', {
		provideHover(document, position) {
			const range = document.getWordRangeAtPosition(position);
			const word = document.getText(range).toLocaleLowerCase();
			if (Object.keys(staticData.charHex2Names[word])) {
				let hexPrefix = '0x';
				let baseVal = parseInt(word, 16);
				let assistA = baseVal;
				assistA = assistA.toString(16);
				let assistB = baseVal + 64;
				assistB = assistB.toString(16);
				let assistC = baseVal + 128;
				assistC = assistC.toString(16);

				// let image = `${charThumbnailsPath}charID_${word}.jpg`
				// console.log(image);

				// // Add image to hover popup
				// const content = new vscode.MarkdownString(`<img src="${image}"/>`);
				// content.supportHtml = true;
				// content.isTrusted = true;
				// content.supportThemeIcons = true;  // to supports codicons
				// content.baseUri = vscode.Uri.file(path.join(context.extensionPath, charThumbnailsPath, path.sep));
				// return new vscode.Hover(content, new vscode.Range(position, position));
				return new vscode.Hover(
					{
						language: "sh4asm",
						value: `Name: ${staticData.charHex2Names[word]} `
							+ `\nHex: ${word} `
							+ `\nDecimal: ${parseInt(word, 16)} `
							+ `\nAssist - α: ${hexPrefix + assistA} `
							+ `\nAssist - β: ${hexPrefix + assistB} `
							+ `\nAssist - γ: ${hexPrefix + assistC} `
						// + `\n\n${content}`
					},
				);
			}
		}

	});

	// vscode.languages.registerHoverProvider('sh4asm', {
	// 	provideHover(document, position, token) {
	// 		const range = document.getWordRangeAtPosition(position, /mov\.\w/); // a word can have a dot and a letter after it
	// 		const word = document.getText(range);

	// 		if (word == asmValue1) {
	// 			return new vscode.Hover({
	// 				language: "sh4asm",
	// 				value: "This moves a long (which is 4 bytes)"
	// 			});
	// 		}
	// 	}
	// });
}

// This method is called when your extension is deactivated
function deactivate() { }

module.exports = {
	activate,
	deactivate

}
