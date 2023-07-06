const vscode = require('vscode');
const path = require('path');

const staticData = require('./sh4asm_staticData.js');

/**
 * @param {vscode.ExtensionContext} context
 */
function activate(context) {
	let disposable = vscode.commands.registerCommand('sh4asm.helloWorld', function () {
		vscode.window.showInformationMessage('Hello World from sh4asm!');
	});

	/* 	
	The command will wrap the selected text
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

	// // Auto-Complete variables (not working right)

	// const MVC2GEN = staticData.MVC2GEN_CONSTANTS
	// const MVC2GEN_ARRAY = [];
	// for (let i = 0; i < MVC2GEN.length; i++) {
	// 	MVC2GEN_ARRAY.push(MVC2GEN[i]);
	// }
	// const LANGUAGES = ['typescriptreact', 'typescript', 'javascript', 'javascriptreact', 'sh4asm', 'asm'];
	// const suggestionsList = [];
	// const triggers = [" "];

	// const completionProvider = vscode.languages.registerCompletionItemProvider(LANGUAGES, {
	// 	provideCompletionItems(document, position, token, context) {
	// 		for (let genIDX = 0; genIDX < MVC2GEN_ARRAY.length; genIDX++) {
	// 			const item = new vscode.CompletionItem(MVC2GEN_ARRAY[genIDX], vscode.CompletionItemKind.Constant,);
	// 			// console.log(MVC2GEN_ARRAY[genIDX])
	// 			suggestionsList.push(item);
	// 		}
	// 		// Put suggestionList into a set to remove duplicates
	// 		let results = [...new Set(suggestionsList)];
	// 		return results;
	// 	}
	// });

	// context.subscriptions.push(completionProvider);

	// Register the commands
	context.subscriptions.push(box);
	context.subscriptions.push(disposable);


	// const charThumbnailsPath = './supportMedia/characterThumbnails/';

	// Hover over 0xXX to get character name
	vscode.languages.registerHoverProvider('sh4asm', {
		provideHover(document, position) {
			const range = document.getWordRangeAtPosition(position,
				/0x\d+\w+(?=.*char)|0x\d+\d+(?=.*char)/);
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

	// Hover MOV.L definition
	vscode.languages.registerHoverProvider('sh4asm', {
		provideHover(document, position, token) {
			let asmValue1 = "mov.l";
			const range = document.getWordRangeAtPosition(position, /mov\.\w/); // a word can have a dot and a letter after it
			const word = document.getText(range);

			if (word == asmValue1) {
				return new vscode.Hover({
					language: "sh4asm",
					value: "This moves a long (which is 4 bytes)"
				});
			}
		}
	});



} // final place to add stuff

// This method is called when your extension is deactivated
function deactivate() { }

module.exports = {
	activate,
	deactivate

}
