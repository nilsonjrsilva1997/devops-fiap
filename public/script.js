// Função para buscar mensagem do backend
async function buscarMensagem() {
    const respostaDiv = document.getElementById('resposta');
    const botao = document.getElementById('btnMensagem');
    
    // Desabilitar botão enquanto processa
    botao.disabled = true;
    botao.textContent = 'Carregando...';
    
    try {
        const response = await fetch('/api/mensagem');
        
        if (!response.ok) {
            throw new Error(`Erro HTTP: ${response.status}`);
        }
        
        const data = await response.json();
        
        // Formatar a resposta
        const mensagemFormatada = `
            <strong>${data.mensagem}</strong><br>
            Status: ${data.status}<br>
            Horário: ${new Date(data.timestamp).toLocaleString('pt-BR')}
        `;
        
        respostaDiv.innerHTML = `<p>${mensagemFormatada}</p>`;
        respostaDiv.classList.add('sucesso');
        respostaDiv.classList.remove('erro');
        
    } catch (erro) {
        console.error('Erro ao buscar dados:', erro);
        
        respostaDiv.innerHTML = `
            <p>Erro ao conectar com o backend<br>
            ${erro.message}</p>
        `;
        respostaDiv.classList.add('erro');
        respostaDiv.classList.remove('sucesso');
    } finally {
        // Reabilitar botão
        botao.disabled = false;
        botao.textContent = 'Clique para chamar API';
    }
}

// Fazer uma chamada automaticamente quando a página carrega
document.addEventListener('DOMContentLoaded', () => {
    console.log('Página carregada!');
    console.log('Endpoint disponível em: /api/mensagem');
});
