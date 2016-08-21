var players = [];

function updatePlayers()
{
	$('#players tbody').html('');
	for(var i = 0; i < players.length; i++)
	{
		var output = '<tr>';
		output += '<td>'+players[i]['ID']+'</td>';
		output += '<td>'+players[i]['name']+'</td>';
		output += '</tr>';
		var player = $(output);
		player.appendTo('#players tbody');
	}
}

function clearPlayers()
{
	players = [];
}

function addPlayer(ID, name)
{
	players.push({ID: ID, name: name});
}