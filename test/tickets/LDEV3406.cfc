component extends="org.lucee.cfml.test.LuceeTestCase" skip=true{
    function beforeAll(){
        variables.uri = createURI("LDEV3406");
    }

    function run( testResults, testBox ){
        describe("Testcase for LDEV-3406", function() {
            it( title="serializeJSON() with struct", body=function( currentSpec ){
                sct = [boolean:true,int:100,string:"string",intString:"1000",booleanString:"true"];
                res = serializeJSON(sct);
                expect(res).toBe('{"BOOLEAN":true,"INT":100,"STRING":"string","INTSTRING":"1000","BOOLEANSTRING":"true"}')
            });
            it( title="serializeJSON() with query column type bit", body=function( currentSpec ){
                qry = queryNew("bitCol","bit",[{"bitCol":0},{"bitCol":1}]);
                expect(serializeJSON(qry)).toBe('{"COLUMNS":["bitCol"],"DATA":[[false],[true]]}');
            });
            it( title="serializeJSON() with query column type integer", body=function( currentSpec ){
                qry = queryNew("intCol","integer",[{"intCol":1000},{"intCol":"1000"}]);
                expect(serializeJSON(qry)).toBe('{"COLUMNS":["intCol"],"DATA":[[1000],[1000]]}');
            });
            it( title="serializeJSON() with query column type varchar", body=function( currentSpec ){
                qry = queryNew("varcharCol","varchar",[{"varcharCol":1000},{"varcharCol":"1000"}]);
                expect(serializeJSON(qry)).toBe('{"COLUMNS":["varcharCol"],"DATA":[["1000"],["1000"]]}');
            });


            it( title="serializeJSON() with JDBC query column type bit", skip="#notHasMysql()#", body=function( currentSpec ){
                var result = _InternalRequest(
                    template : "#variables.uri#/LDEV3406.cfm",
                    forms = {colname:"bitCol"}
                ).fileContent.trim();
                expect(result).toBe('{"COLUMNS":["bitCol"],"DATA":[[false],[true]]}');
            });
            it( title="serializeJSON() with JDBC query column type integer", skip="#notHasMysql()#", body=function( currentSpec ){
                var result = _InternalRequest(
                    template : "#variables.uri#/LDEV3406.cfm",
                    forms : {colname:"intCol"}
                ).fileContent.trim();
                expect(result).toBe('{"COLUMNS":["intCol"],"DATA":[[1000],[1000]]}');
            });
            it( title="serializeJSON() with JDBC query column type varchar", skip="#notHasMysql()#", body=function( currentSpec ){
                 var result = _InternalRequest(
                    template : "#variables.uri#/LDEV3406.cfm",
                    forms : {colname:"varcharCol"}
                ).fileContent.trim();
                expect(result).toBe('{"COLUMNS":["varcharCol"],"DATA":[["1000"],["1000"]]}');
            });
        });
    }

    function afterAll() {
        if (!notHasMysql()) {
            query datasource=server.getDatasource("mysql") {
                echo("DROP TABLE IF EXISTS LDEV3406");
            }
        }
    }

    private boolean function notHasMysql() {
        return !structCount(server.getDatasource("mysql"));
    }

    private string function createURI(string calledName){
        var baseURI = "/test/#listLast(getDirectoryFromPath(getCurrenttemplatepath()),"\/")#/";
        return baseURI&""&calledName;
    }
}