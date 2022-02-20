Class Kafka.Helper Extends %RegisteredObject
{

Parameter port = 55000;

Parameter host = "127.0.0.1";

Parameter dll = "C:\kafkaaqs\AQSKafkaDll7.dll";

Parameter nombreGateway = "NetGateway";

Parameter timeout = 2;

ClassMethod install() As %Status
{
        Set resGateway = ..initGateway()

        Q:(resGateway'=$$$OK) $$$ERROR()

        Do ..importLibrary()

        Quit $$$OK
}

ClassMethod importLibrary()
{
        Do ##class(AQSKafkaDll.ImportHelper).AQExpressImport(..#dll,..#port)
}

ClassMethod initGateway(ByRef Gateway As %Net.Remote.Gateway) As %Status
{
        Set Util = ##class(%Net.Remote.Utility).%New()
        Set Service = ##class(%Net.Remote.Service).%New()
        Set Gateway = ##class(%Net.Remote.Gateway).%New()

        Set namespace=$zu(5)
        Set estado = Util.CheckGateway(..#host,..#port,0)
        If (estado=0)
        {
                Set estado = Service.StartGateway(..#nombreGateway,0)
        }

        Q:estado'=1 $$$ERROR()

        Set result=Gateway.%Connect(..#host,..#port,namespace,..#timeout)

        Quit result
}

ClassMethod createTopic(topic As %String, server As %String, keyId As %String)
{
        Set ^KAFKA("TOPICS",topic)=""
        Set ^KAFKA("TOPICS",topic,"server")=server
        Set ^KAFKA("TOPICS",topic,"keyId")=keyId
}

ClassMethod deleteTopic(topic As %String)
{
        Kill ^KAFKA("TOPICS",topic)
}

}
