document.addEventListener('DOMContentLoaded', () => {
    const initialView = window.location.hash || '#players';
    updateActiveLink(initialView);
    loadView(initialView);

    document.querySelectorAll('.sidebar-nav a').forEach(link => {
        link.addEventListener('click', (e) => {
            if (e.currentTarget.getAttribute('href').startsWith('#')) {
                const viewName = e.currentTarget.hash;
                updateActiveLink(viewName);
                loadView(viewName);
            }
        });
    });
});

function updateActiveLink(viewName) {
    document.querySelectorAll('.sidebar-nav a').forEach(link => {
        link.classList.toggle('active', link.hash === viewName);
    });
}

function loadView(viewName) {
    switch (viewName) {
        case '#players': loadPlayers(); break;
        case '#teams': loadTeams(); break;
        case '#coaches': loadCoaches(); break;
        case '#matches': loadMatches(); break;
        case '#umpires': loadUmpires(); break;
        default: document.getElementById('main-content').innerHTML = `<h2>Welcome</h2>`;
    }
}

// Universal Modal and Toast Functions
function openModal(title, formHTML) {
    document.getElementById('modal-body').innerHTML = `<h3>${title}</h3>${formHTML}`;
    document.getElementById('form-modal').style.display = 'flex';
}

function closeModal() {
    document.getElementById('form-modal').style.display = 'none';
    document.getElementById('modal-body').innerHTML = '';
}

function showToast(message, type = 'success') {
    const toast = document.createElement('div');
    toast.className = `toast ${type} show`;
    toast.textContent = message;
    document.body.appendChild(toast);
    setTimeout(() => {
        toast.classList.remove('show');
        setTimeout(() => document.body.removeChild(toast), 500);
    }, 3000);
}

// Generic form submission handler
async function handleFormSubmit(event, url, loadViewFunction) {
    event.preventDefault();
    const formData = new FormData(event.target);
    try {
        const response = await fetch(url, { method: 'POST', body: formData });
        const result = await response.json();
        if (result.success) {
            closeModal();
            loadViewFunction();
            showToast(result.message);
        } else {
            alert(`Error: ${result.message}`);
        }
    } catch (error) {
        alert(`An error occurred: ${error}`);
    }
}

// Generic delete handler
async function handleDelete(id, name, id_field, url, loadViewFunction) {
    if (confirm(`Are you sure you want to delete ${name} ${id}?`)) {
        const formData = new FormData();
        formData.append(id_field, id);
        try {
            const response = await fetch(url, { method: 'POST', body: formData });
            const result = await response.json();
            if (result.success) {
                loadViewFunction();
                showToast(result.message);
            } else {
                alert(`Error: ${result.message}`);
            }
        } catch (error) {
            alert(`An error occurred: ${error}`);
        }
    }
}


// --- PLAYER MANAGEMENT ---
async function loadPlayers() {
    const response = await fetch('/api/players');
    const players = await response.json();
    document.getElementById('main-content').innerHTML = `
        <h2>Manage Players</h2>
        <button class="add-new-btn" onclick="openAddPlayerModal()">Add New Player</button>
        <table>
            <thead><tr><th>ID</th><th>Name</th><th>Team</th><th>Role</th><th>Actions</th></tr></thead>
            <tbody>
                ${players.map(p => `
                    <tr>
                        <td>${p.player_id}</td><td>${p.player_name}</td><td>${p.team_id}</td><td>${p.player_role}</td>
                        <td>
                            <button onclick="openEditPlayerModal('${p.player_id}','${p.player_name}','${p.team_id}','${p.player_role}','${p.bat}','${p.bowl}')">Edit</button>
                            <button class="delete-btn" onclick="handleDelete('${p.player_id}','Player','player_id','/api/player/delete', loadPlayers)">Delete</button>
                        </td>
                    </tr>`).join('')}
            </tbody>
        </table>`;
}
function openAddPlayerModal() {
    const formHTML = `<form onsubmit="handleFormSubmit(event, '/api/player/add', loadPlayers)">
        <input type="text" name="player_id" placeholder="Player ID" required>
        <input type="text" name="player_name" placeholder="Player Name" required>
        <input type="text" name="team_id" placeholder="Team ID" required>
        <input type="text" name="player_role" placeholder="Player Role" required>
        <input type="text" name="bat" placeholder="Batting Hand" required>
        <input type="text" name="bowl" placeholder="Bowling Hand" required>
        <button type="submit">Add Player</button></form>`;
    openModal("Add New Player", formHTML);
}
function openEditPlayerModal(id, name, team_id, role, bat, bowl) {
    const formHTML = `<form onsubmit="handleFormSubmit(event, '/api/player/update', loadPlayers)">
        <input type="hidden" name="player_id" value="${id}">
        <input type="text" name="player_name" value="${name}" required>
        <input type="text" name="team_id" value="${team_id}" required>
        <input type="text" name="player_role" value="${role}" required>
        <input type="text" name="bat" value="${bat}" required>
        <input type="text" name="bowl" value="${bowl}" required>
        <button type="submit">Update Player</button></form>`;
    openModal(`Edit Player: ${id}`, formHTML);
}

// --- TEAM MANAGEMENT ---
async function loadTeams() {
    const response = await fetch('/api/teams');
    const teams = await response.json();
    document.getElementById('main-content').innerHTML = `
        <h2>Manage Teams</h2>
        <button class="add-new-btn" onclick="openAddTeamModal()">Add New Team</button>
        <table>
            <thead><tr><th>ID</th><th>Name</th><th>Ranking</th><th>Group</th><th>Actions</th></tr></thead>
            <tbody>
                ${teams.map(t => `
                    <tr>
                        <td>${t.team_id}</td><td>${t.team_name}</td><td>${t.team_ranking}</td><td>${t.team_group}</td>
                        <td>
                            <button onclick="openEditTeamModal('${t.team_id}','${t.team_name}','${t.team_ranking}','${t.team_group}')">Edit</button>
                            <button class="delete-btn" onclick="handleDelete('${t.team_id}','Team','team_id','/api/team/delete', loadTeams)">Delete</button>
                        </td>
                    </tr>`).join('')}
            </tbody>
        </table>`;
}
function openAddTeamModal() {
    const formHTML = `<form onsubmit="handleFormSubmit(event, '/api/team/add', loadTeams)">
        <input type="text" name="team_id" placeholder="Team ID" required>
        <input type="text" name="team_name" placeholder="Team Name" required>
        <input type="number" name="team_ranking" placeholder="Ranking" required>
        <input type="text" name="team_group" placeholder="Group" required>
        <button type="submit">Add Team</button></form>`;
    openModal("Add New Team", formHTML);
}
function openEditTeamModal(id, name, ranking, group) {
    const formHTML = `<form onsubmit="handleFormSubmit(event, '/api/team/update', loadTeams)">
        <input type="hidden" name="team_id" value="${id}">
        <input type="text" name="team_name" value="${name}" required>
        <input type="number" name="team_ranking" value="${ranking}" required>
        <input type="text" name="team_group" value="${group}" required>
        <button type="submit">Update Team</button></form>`;
    openModal(`Edit Team: ${id}`, formHTML);
}

// --- COACH MANAGEMENT ---
async function loadCoaches() {
    const response = await fetch('/api/coaches');
    const coaches = await response.json();
    document.getElementById('main-content').innerHTML = `
        <h2>Manage Coaches</h2>
        <button class="add-new-btn" onclick="openAddCoachModal()">Add New Coach</button>
        <table>
            <thead><tr><th>ID</th><th>Name</th><th>Team ID</th><th>Staff Count</th><th>Actions</th></tr></thead>
            <tbody>
                ${coaches.map(c => `
                    <tr>
                        <td>${c.coach_id}</td><td>${c.coach_name}</td><td>${c.team_id}</td><td>${c.support_staff_count}</td>
                        <td>
                            <button onclick="openEditCoachModal('${c.coach_id}','${c.coach_name}','${c.team_id}','${c.support_staff_count}')">Edit</button>
                            <button class="delete-btn" onclick="handleDelete('${c.coach_id}','Coach','coach_id','/api/coach/delete', loadCoaches)">Delete</button>
                        </td>
                    </tr>`).join('')}
            </tbody>
        </table>`;
}
function openAddCoachModal() {
    const formHTML = `<form onsubmit="handleFormSubmit(event, '/api/coach/add', loadCoaches)">
        <input type="text" name="coach_id" placeholder="Coach ID" required>
        <input type="text" name="coach_name" placeholder="Name" required>
        <input type="text" name="team_id" placeholder="Team ID" required>
        <input type="number" name="support_staff_count" placeholder="Staff Count" value="0" required>
        <button type="submit">Add Coach</button></form>`;
    openModal("Add New Coach", formHTML);
}
function openEditCoachModal(id, name, team_id, staff_count) {
    const formHTML = `<form onsubmit="handleFormSubmit(event, '/api/coach/update', loadCoaches)">
        <input type="hidden" name="coach_id" value="${id}">
        <input type="text" name="coach_name" value="${name}" required>
        <input type="text" name="team_id" value="${team_id}" required>
        <input type="number" name="support_staff_count" value="${staff_count}" required>
        <button type="submit">Update Coach</button></form>`;
    openModal(`Edit Coach: ${id}`, formHTML);
}

// --- UMPIRE MANAGEMENT ---
async function loadUmpires() {
    const response = await fetch('/api/umpires');
    const umpires = await response.json();
    document.getElementById('main-content').innerHTML = `
        <h2>Manage Umpires</h2>
        <button class="add-new-btn" onclick="openAddUmpireModal()">Add New Umpire</button>
        <table>
            <thead><tr><th>ID</th><th>Name</th><th>Country</th><th>Actions</th></tr></thead>
            <tbody>
                ${umpires.map(u => `
                    <tr>
                        <td>${u.umpire_id}</td><td>${u.umpire_name}</td><td>${u.country}</td>
                        <td>
                            <button onclick="openEditUmpireModal('${u.umpire_id}','${u.umpire_name}','${u.country}')">Edit</button>
                            <button class="delete-btn" onclick="handleDelete('${u.umpire_id}','Umpire','umpire_id','/api/umpire/delete', loadUmpires)">Delete</button>
                        </td>
                    </tr>`).join('')}
            </tbody>
        </table>`;
}
function openAddUmpireModal() {
    const formHTML = `<form onsubmit="handleFormSubmit(event, '/api/umpire/add', loadUmpires)">
        <input type="text" name="umpire_id" placeholder="Umpire ID" required>
        <input type="text" name="umpire_name" placeholder="Name" required>
        <input type="text" name="country" placeholder="Country" required>
        <button type="submit">Add Umpire</button></form>`;
    openModal("Add New Umpire", formHTML);
}
function openEditUmpireModal(id, name, country) {
    const formHTML = `<form onsubmit="handleFormSubmit(event, '/api/umpire/update', loadUmpires)">
        <input type="hidden" name="umpire_id" value="${id}">
        <input type="text" name="umpire_name" value="${name}" required>
        <input type="text" name="country" value="${country}" required>
        <button type="submit">Update Umpire</button></form>`;
    openModal(`Edit Umpire: ${id}`, formHTML);
}

// --- MATCH MANAGEMENT ---
async function loadMatches() {
    const response = await fetch('/api/matches');
    const matches = await response.json();
    document.getElementById('main-content').innerHTML = `
        <h2>Manage Matches</h2>
        <button class="add-new-btn" onclick="openAddMatchModal()">Add New Match</button>
        <table>
            <thead><tr><th>ID</th><th>Date</th><th>Teams</th><th>Winner</th><th>Umpire</th><th>Stadium</th><th>Actions</th></tr></thead>
            <tbody>
                ${matches.map(m => `
                    <tr>
                        <td>${m.match_id}</td>
                        <td>${new Date(m.match_date).toLocaleDateString()}</td>
                        <td>${m.team_1_id} vs ${m.team_2_id}</td>
                        <td>${m.winner}</td>
                        <td>${m.umpire_name}</td>
                        <td>${m.stadium_name}</td>
                        <td>
                            <button class="delete-btn" onclick="handleDelete('${m.match_id}','Match','match_id','/api/match/delete', loadMatches)">Delete</button>
                        </td>
                    </tr>`).join('')}
            </tbody>
        </table>`;
}
function openAddMatchModal() {
    const teamOptions = PRELOADED_DATA.teams.map(t => `<option value="${t.team_id}">${t.team_name}</option>`).join('');
    const umpireOptions = PRELOADED_DATA.umpires.map(u => `<option value="${u.umpire_id}">${u.umpire_name}</option>`).join('');
    const stadiumOptions = PRELOADED_DATA.stadiums.map(s => `<option value="${s.stadium_id}">${s.stadium_name}</option>`).join('');
    
    const formHTML = `<form onsubmit="handleFormSubmit(event, '/api/match/add', loadMatches)">
        <input type="number" name="match_id" placeholder="Match ID" required>
        <input type="date" name="match_date" required>
        <label>Team 1:</label><select name="team_1_id">${teamOptions}</select>
        <label>Team 2:</label><select name="team_2_id">${teamOptions}</select>
        <label>Winner:</label><select name="winner">${teamOptions}</select>
        <label>Umpire:</label><select name="ump_id">${umpireOptions}</select>
        <label>Stadium:</label><select name="stadium_id">${stadiumOptions}</select>
        <input type="text" name="match_group" placeholder="Group">
        <button type="submit">Add Match</button></form>`;
    openModal("Add New Match", formHTML);
}
// Edit for matches is complex due to dropdowns; this version only supports Add/Delete for simplicity.