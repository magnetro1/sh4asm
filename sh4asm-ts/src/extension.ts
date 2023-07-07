import * as vscode from 'vscode';
import * as staticData from './sh4asm_staticData';
import * as path from 'path';

const localPath = 'supportMedia/characterThumbnails'

export function activate(context: vscode.ExtensionContext) {

  let disposable = vscode.commands.registerCommand('sh4asm.helloWorld', () => {
    vscode.window.showInformationMessage('Hello World from sh4asm-ts! This is hard');
  });

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


  context.subscriptions.push(disposable);
  context.subscriptions.push(box);


  vscode.languages.registerHoverProvider('sh4asm', {
    provideHover(document, position, token) {
      const range = document.getWordRangeAtPosition(position,
        /0x\d+\w+(?=.*char)|0x\d+\d+(?=.*char)/);
      const word = document.getText(range);
      let hexPrefix = '0x';
      let baseVal = parseInt(word, 16);
      let assistA: number | string = 0;
      let assistB: number | string = 0;
      let assistC: number | string = 0;
      assistA = baseVal.toString(16);
      // assistA = assistA.toString(16);
      assistB = baseVal + 64;
      assistB = assistB.toString(16);
      assistC = baseVal + 128;
      assistC = assistC.toString(16);
      let md = new vscode.MarkdownString();
      md.baseUri = vscode.Uri.file(path.join(context.extensionPath, localPath, path.sep));
      const imageHover = md.appendMarkdown(`![char](${md.baseUri}/charID_${word}.jpg)`);
      const dataHover =
        `\n\nName: ${staticData.characters_Hex_2_Names[word]} `
        + `\n\nHex: ${word} `
        + `\n\nDecimal: ${parseInt(word, 16)} `
        + `\n\nAssist - α: ${word} `
        + `\n\nAssist - β: ${hexPrefix + assistB} `
        + `\n\nAssist - γ: ${hexPrefix + assistC} `;

      if (Object.keys(staticData.characters_Hex_2_Names).includes(word)) {
        return new vscode.Hover(
          [imageHover, dataHover]
        );
      }
    }
  });
  // {
  //   provideHover() {
  //     const markdownString = new vscode.MarkdownString();
  // markdownString.appendText("Hello: https://github.com/microsoft/vscode/issues/142494")
  //     return new vscode.Hover(markdownString);
  //   }
  // })

  // Hover MOV.L definition
  // vscode.languages.registerHoverProvider('sh4asm', {
  //   provideHover(document, position, token) {
  //     let asmValue1 = "mov.l";
  //     const range = document.getWordRangeAtPosition(position, /mov\.\w/); // a word can have a dot and a letter after it
  //     const word = document.getText(range);

  //     if (word == asmValue1) {
  //       return new vscode.Hover({
  //         language: "sh4asm",
  //         value: "This moves a long (which is 4 bytes)"
  //       });
  //     }
  //   }
  // });

}
export function deactivate() { }
