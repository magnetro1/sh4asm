import * as vscode from 'vscode';
import * as staticData from './sh4asm_staticData';
import * as path from 'path';

const thumbsPath = 'supportMedia/characterThumbnails'

export function activate(context: vscode.ExtensionContext) {

  let disposable = vscode.commands.registerCommand('sh4asm.helloWorld', () => {
    vscode.window.showInformationMessage('Hello World from sh4asm-ts!');
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

  // Hover character definition
  vscode.languages.registerHoverProvider('sh4asm', {
    provideHover(document, position, token) {
      const range = document.getWordRangeAtPosition(position,
        /0x\d+\w+(?=.*char)|0x\d+\d+(?=.*char)/);
      const word = document.getText(range);
      // Hex math for character assist values
      let hexPrefix = '0x';
      let baseVal = parseInt(word, 16);
      // let assistA: number | string = 0; // doesn't need to be calculated
      let assistB: number | string = 0;
      let assistC: number | string = 0;
      // assistA = baseVal.toString(16);
      // assistA = assistA.toString(16);
      assistB = baseVal + 64;
      assistB = assistB.toString(16);
      assistC = baseVal + 128;
      assistC = assistC.toString(16);
      // Create hover for character image
      let imageMD = new vscode.MarkdownString();
      imageMD.baseUri = vscode.Uri.file(path.join(context.extensionPath, thumbsPath, path.sep));
      let imageHover = imageMD.appendMarkdown(`![char](${imageMD.baseUri}/charID_${word}.jpg)`);

      // let dataMD = new vscode.MarkdownString();
      // dataMD.appendMarkdown(
      //   `\n\n\*Name:\* ${staticData.characters_Hex_2_Names[word]}`
      //   + `\n\n\*Hex:\* ${word}`
      //   + `\n\n\*Decimal:\* ${parseInt(word, 16)}`
      //   + `\n\n\*Assist - α:\* ${word}` // doesn't need to be calculated
      //   + `\n\n\*Assist - β:\* ${hexPrefix + assistB}`
      //   + `\n\n\*Assist - γ:\* ${hexPrefix + assistC}`
      // );
      let dataMD = new vscode.MarkdownString();
      // Format the "Name" in bold
      dataMD.appendMarkdown(`\n\nName: ${staticData.characters_Hex_2_Names[word]}\n\n`);
      dataMD.appendCodeblock(`Hex: ${word}`, 'sh4asm');
      dataMD.appendCodeblock(`Decimal: ${parseInt(word, 16)}`, 'sh4asm');

      dataMD.appendCodeblock(`Assist - α: ${word}`, 'sh4asm');
      dataMD.appendCodeblock(`Assist - β: ${hexPrefix + assistB}`, 'sh4asm');
      dataMD.appendCodeblock(`Assist - γ: ${hexPrefix + assistC}`, 'sh4asm');

      // dataMD.appendMarkdown(`\n\n\*Name:\* ${staticData.characters_Hex_2_Names[word]}`);
      const dataHover = dataMD;
      if (Object.keys(staticData.characters_Hex_2_Names).includes(word)) {
        return new vscode.Hover(
          [imageHover, dataHover]
        );
      }
    }
  });

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
