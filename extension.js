// The module 'vscode' contains the VS Code extensibility API
// Import the module and reference it with the alias vscode in your code below
const vscode = require('vscode');

// This method is called when your extension is activated
// Your extension is activated the very first time the command is executed

/**
 * @param {vscode.ExtensionContext} context
 */
function activate(context) {

	// Use the console to output diagnostic information (console.log) and errors (console.error)
	// This line of code will only be executed once when your extension is activated
	console.log('Congratulations, your extension "sh4asm" is now active!');

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

	// Hover over a word to get a popup
	vscode.languages.registerHoverProvider('sh4asm', {
		provideHover(document, position, token) {
			const range = document.getWordRangeAtPosition(position, /mov\.\w/); // a word can have a dot and a letter after it
			const word = document.getText(range);
			const asmValue = 'mov.l' // the value we want to hover over, the previous regex is necessary to get the whole thing.
			if (word == asmValue) {
				return new vscode.Hover({
					language: "sh4asm",
					value: "Popup text\nThis moves a long value"
				});
			}
		}
	});
}

// This method is called when your extension is deactivated
function deactivate() { }

module.exports = {
	activate,
	deactivate

}
