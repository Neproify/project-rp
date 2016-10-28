var ranks = [];

function updateRanks()
{
    $('#ranks tbody').html('');
    for(var i = 0; i < ranks.length; i++)
    {
        var output = '<tr>';
        output += '<td><input id="name-'+ranks[i]['UID']+'" type="text" value="'+ranks[i]['name']+'" /></td>';
		if(ranks[i]['permissions'] & 1 == true)
		{
        output += `<td><input id="memberManagment-`+ranks[i]['UID']+`" type="checkbox" value="" checked>
		</td>`;
		}
		else
		{
			output += `<td><input id="memberManagment-`+ranks[i]['UID']+`" type="checkbox" value="">
		</td>`;
		}
        output += '<td>';
		output += '<a href="#" onclick="event.preventDefault(); saveRank('+ranks[i]['UID']+');">Zapisz</a> ';
		output += '<a href="#" onclick="event.preventDefault(); deleteRank('+ranks[i]['UID']+');">Usuń</a>';
		output += '</td>';
        output += '</tr>';
        var rank = $(output);
        rank.appendTo('#ranks tbody');
    }
}

function cleanRanks()
{
	var ranks = [];
}

function addRank(UID, name, permissions)
{
	ranks.push({UID: UID, name: name, permissions: permissions});
}

function saveRank(UID)
{
	var rankName = $('#name-'+UID).val();
	var permissions = 0;
	if($('#memberManagment-'+UID).prop('checked'))
	{
		permissions = permissions | 1;
	}
	mta.triggerEvent('saveGroupRank', UID, rankName, permissions);
}

function deleteRank(UID)
{
	mta.triggerEvent('deleteGroupRank', UID);
}