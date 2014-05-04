/*
		DataInsert - an official product by Zachary Griffeth

		Developers
			- Zachary Griffeth (Skyrise)

		FILE: FINSERT.PWN

        Copyright (c) 2014 Zachary Griffeth

        YOU MAY NOT UNDER ANY CIRCUMSTANCE:
        use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
        the Software WITHOUT EXPRESS WRITTEN PERMISSION FROM COPYRIGHT OWNER.

        THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
        IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
        FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
        COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
        IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
        CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

        ALL RIGHTS OF INCLUDES/SOURCES ARE TO THEIR RESPECTIVE OWNERS.
*/

#include <a_samp>
#include <a_mysql>
#include <sscanf2>
#include <zcmd>

#define SQL_SERVER 	"localhost"
#define SQL_USER	"root"
#define SQL_DB		"test"
#define SQL_PASS	""

forward MySQL_Finish();

new fSQLHandle;

public OnFilterScriptInit()
{
    fSQLHandle = mysql_connect( SQL_SERVER, SQL_USER, SQL_DB, SQL_PASS );
    //mysql_log();
	print("\n--------------------------------------");
	print(" Skyrise's Resources Library");
	print(" MySQL Data Insertion, by Skyrise.");
	print("--------------------------------------\n");
	return 1;
}

public OnFilterScriptExit()
{
	mysql_close(fSQLHandle);
	return 1;
}

CMD:insert(playerid, params[]) 
{
	new query[128], escapedstring[128], rows;
	if(!sscanf(params, "I(-1)s[128]", rows, query)) {
		if(rows != -1) {
			mysql_real_escape_string(query, escapedstring, fSQLHandle);
			for(new i = 0; i < rows; i++) {
				mysql_function_query(fSQLHandle, escapedstring, false, "MySQL_Finish", "");
			}
		}
		else {
			mysql_real_escape_string(query, escapedstring, fSQLHandle);
			mysql_function_query(fSQLHandle, escapedstring, false, "MySQL_Finish", "");
		}
		SendClientMessage(playerid, -1, "Query sent.");
	}
	else {
		SendClientMessage(playerid, -1, "Please enter a query.");
	}
	return 1;
}

public MySQL_Finish() 
{
	return (!mysql_affected_rows(fSQLHandle)) ? print("[RESOURCE DEBUG] Failed to affect rows.") : (1);
}
