var members = [];
var ranks = [];

function updateMembers()
{
	$('#members tbody').html('');
	for(var i = 0; i < members.length; i++)
	{
		var output = '<tr id="'+members[i]['UID']+'">';
		output += '<td>'+members[i]['name']+'</td>';
		output += '<td><select id="ranks-'+members[i]['UID']+'">';
		for(var i2 = 0; i2 < ranks.length; i2++)
		{
			output += '<option value="'+ranks[i2]['UID']+'"';
			if(members[i]['currentRank'] == ranks[i2]['UID'])
			{
				output += 'selected';
			}
			output += '>'+ranks[i2]['name']+'</option>';
		}
		output += '</select></td>';
		output += '<td><a href="#" onclick="event.preventDefault(); saveMember('+members[i]['UID']+')">Zapisz</a> <a href="#" onclick="event.preventDefault(); kickMember('+members[i]['UID']+')">Wyrzuć</a></td>';
		output += '</tr>';
		var member = $(output);
		member.appendTo('#members tbody');
	}
}

function cleanMembers()
{
	var members = [];
}

function cleanRanks()
{
	var ranks = [];
}

function addMember(UID, name, currentRank)
{
	members.push({UID: UID, name: name, currentRank: currentRank});
}

function addRank(UID, name)
{
	ranks.push({UID: UID, name: name});
}

function saveMember(UID)
{
	var rankUID = $('#ranks-'+UID).val();
	mta.triggerEvent('saveGroupMember', UID, rankUID);
}

function kickMember(UID)
{
	mta.triggerEvent('kickGroupMember', UID);
}