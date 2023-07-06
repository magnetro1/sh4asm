import * as vscode from 'vscode';
import * as staticData from './sh4asm_staticData';

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
  // // Hover over 0xXX to get character name
  // vscode.languages.registerHoverProvider('sh4asm', {
  //   provideHover(document, position) {
  //     const range = document.getWordRangeAtPosition(position,
  //       /0x\d+\w+(?=.*char)|0x\d+\d+(?=.*char)/);
  //     const word = document.getText(range).toLocaleLowerCase();
  //     console.log(word);
  //     console.log(staticData.characters_Hex_2_Names[word]);

  //     if (Object.keys(staticData.characters_Hex_2_Names[word])) {
  //       console.log('found');

  //       let hexPrefix = '0x';
  //       let baseVal = parseInt(word, 16);
  //       let assistA: number | string = 0;
  //       let assistB: number | string = 0;
  //       let assistC: number | string = 0;
  //       assistA = baseVal.toString(16);
  //       // assistA = assistA.toString(16);
  //       assistB = baseVal + 64;
  //       assistB = assistB.toString(16);
  //       assistC = baseVal + 128;
  //       assistC = assistC.toString(16);

  //       // let image = `${charThumbnailsPath}charID_${word}.jpg`
  //       // console.log(image);

  //       // // Add image to hover popup
  //       // const content = new vscode.MarkdownString(`<img src="${image}"/>`);
  //       // content.supportHtml = true;
  //       // content.isTrusted = true;
  //       // content.supportThemeIcons = true;  // to supports codicons
  //       // content.baseUri = vscode.Uri.file(path.join(context.extensionPath, charThumbnailsPath, path.sep));
  //       // return new vscode.Hover(content, new vscode.Range(position, position));
  //       return new vscode.Hover(
  //         {
  //           language: "sh4asm",
  //           value: `Name: ${staticData.characters_Hex_2_Names[word]} `
  //             + `\nHex: ${word} `
  //             + `\nDecimal: ${parseInt(word, 16)} `
  //           // + `\nAssist - α: ${hexPrefix + assistA} `
  //           // + `\nAssist - β: ${hexPrefix + assistB} `
  //           // + `\nAssist - γ: ${hexPrefix + assistC} `
  //           // + `\n\n${content}`
  //         },
  //       );
  //     }
  //     else {
  //       console.log('not found');

  //     }
  //   }
  // });
  context.subscriptions.push(disposable);
  context.subscriptions.push(box);

  // for (const [key, value] of Object.entries(staticData.characters_Hex_2_Names)) {
  //   console.log(`${key}: ${value}`);
  // }

  vscode.languages.registerHoverProvider('sh4asm', {
    async provideHover(document, position, token) {
      const range = document.getWordRangeAtPosition(position);
      const word = document.getText(range);

      if (word == "Ryu") {
        return new vscode.Hover({
          language: "sh4asm",
          value: "This is the main character of the Street Fighter series"
        });
      }
    }
  });
  vscode.languages.registerHoverProvider(
    [
      'sh4asm',
      "javascript",  // only this works
      "typescript",
      "javascriptreact",
      "typescriptreact",
      "json",
      "jsonc",
    ],
    {
      provideHover() {
        const markdownString = new vscode.MarkdownString();
        markdownString.appendText("Hello: https://github.com/microsoft/vscode/issues/142494")
        return new vscode.Hover(markdownString);
      }
    })

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
