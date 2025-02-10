# Game Project (Projeto de Jogo)
Um projeto de escola sobre desenvolver um jogo.

## Baixando o repositório
- Se você estiver no computador da escola:
    - Pressione a tecla do Windows e cole este comando no menu iniciar que aparecer (e pressione Enter):
    ```
    powershell -Command "cd $([System.Environment]::GetFolderPath('UserProfile') + '\Downloads'); Invoke-WebRequest -Uri https://github.com/Yohanan-Al/game-project/raw/refs/heads/dev/.scripts/download_repo.ps1 -OutFile .\download_repo.ps1; & .\download_repo.ps1"
    ```
    - Forneça as informações que a nova tela pedir e espere ela terminar (Godot aparecer)
- Se você estiver no seu próprio computador:
    - Leia o livro do Git do início até, no mínimo, o capítulo 2.1: https://git-scm.com/book/pt-br/v2/Come%c3%a7ando-Sobre-Controle-de-Vers%c3%a3o
        - Você também pode assistir este vídeo para pegar uma visão geral do Git com o Godot: https://www.youtube.com/watch?v=1vWzOnu4Nq0
    - Baixe, instale e configure o Git conforme o livro mostra
    - Clone este projeto (como fazer isso é explicado no capítulo 2.1 do livro)
    - Abra a pasta ".scripts" na pasta do projeto e clique duas vezes no arquivo "setup_godot.ps1" (se te perguntar com qual programa abrir, escolha "Powershell")
        - Obs.: você pode clicar neste arquivo toda vez que quiser abrir o Godot neste projeto

## Usando Git no Godot
- Este projeto utiliza o plugin oficial do Godot para o Git
- Para utilizá-lo, vai na aba "Commit" no canto superior direito da tela (você pode precisar ter que clicar na seta ao lado de "Histórico")
- O workflow mais básico que você pode seguir é:
    - Ir na aba "Commit" e clicar na seta virada para baixo no canto inferior direito da tela ("git pull")
    - Fazer as modificações que você quer no projeto
    - Ir na aba "Commit" e clicar na seta apontada para baixo na seção "Alterações não preparadas" ("git add .")
    - Escrever uma mensagem descritiva sobre a alteração que você fez na seção "Mensagem de Commit" e clicar em "Criar commit" ("git commit")
    - Clicar na seta virada para cima no canto inferior direito da tela ("git push")