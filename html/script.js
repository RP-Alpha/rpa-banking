let currentBalance = 0;
let currentAction = null;

window.addEventListener('message', (event) => {
    const data = event.data;
    if (data.action === 'openBox') {
        document.getElementById('app').classList.remove('hidden');
        updateUI(data.data);
    } else if (data.action === 'close') {
        closeBank();
    }
});

function updateUI(data) {
    document.getElementById('player-name').innerText = data.name;
    document.getElementById('balance-amount').innerText = data.balance.toLocaleString();
    currentBalance = data.balance;

    // Clear list
    const list = document.getElementById('transaction-list');
    list.innerHTML = '';

    // Add dummy history if empty (or real if passed)
    if (data.history && data.history.length > 0) {
        data.history.forEach(tx => {
            addTransaction(tx.label, tx.amount);
        });
    } else {
        addTransaction("Account Synced", 0);
    }
}

function addTransaction(label, amount) {
    const list = document.getElementById('transaction-list');
    const li = document.createElement('li');
    const isPositive = amount >= 0;

    li.innerHTML = `
        <span class="t-type">${label}</span>
        <span class="t-amount ${isPositive ? 'positive' : 'negative'}">${isPositive ? '+' : ''}$${Math.abs(amount).toLocaleString()}</span>
    `;
    list.prepend(li); // Newest first
}

function closeBank() {
    document.getElementById('app').classList.add('hidden');
    fetch(`https://${GetParentResourceName()}/close`, {
        method: 'POST'
    });
}

function openModal(action) {
    currentAction = action;
    document.getElementById('modal-title').innerText = action.charAt(0).toUpperCase() + action.slice(1);
    document.getElementById('modal').classList.remove('hidden');
    document.getElementById('amount-input').value = '';
    document.getElementById('amount-input').focus();
}

function closeModal() {
    document.getElementById('modal').classList.add('hidden');
    currentAction = null;
}

function submitTransaction() {
    const amount = parseInt(document.getElementById('amount-input').value);
    if (!amount || amount <= 0) return;

    fetch(`https://${GetParentResourceName()}/${currentAction}`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ amount: amount })
    });

    closeModal();
}
