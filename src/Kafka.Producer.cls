Class Kafka.Producer Extends %RegisteredObject
{

ClassMethod sendMessage(topic As %String, message As %String)
{
        Set result="Topic not found"
        Set resMessage = 0

        Q:($D(^KAFKA("TOPICS",topic))=0) result

        Set result="Error no se pudo entregar"

        Set bootstrapServer = $G(^KAFKA("TOPICS",topic,"server"))
        Set keyId = $G(^KAFKA("TOPICS",topic,"keyId"))

        try{

                Set resGateway=##class(Kafka.Helper).initGateway()


                If (resGateway=$$$OK)
                {
                        Set Gateway = ##class(%Net.Remote.Gateway).%New()

                        Set estado = ##class(Kafka.Helper).initGateway(.Gateway)


                        Set kafka=##class(AQSKafkaDll.ProducerHelper3).%New(Gateway)

                        If (..isValidJson(message))
                        {

                                Set resMessage = kafka.Produce(topic, bootstrapServer, message,keyId)
                        }Else{
                                Set resMessage="Error not valid json"
                        }

                        Do Gateway.%Disconnect()
                }



        }catch(e)
        {
                Set resMessage = %objlasterror
                ZW %objlasterror
        }

        If (resMessage'="enviado ok")
        {
                Set sequence = $I(^KAFKA("TOPICS",topic,"ERRORS"))
                Set ^KAFKA("TOPICS",topic,"ERRORS",sequence,"MESSAGE")=message
                Set ^KAFKA("TOPICS",topic,"ERRORS",sequence,"RESULT")=resMessage

        }else{
                Set result=$$$OK
        }




        Quit result
}

ClassMethod sendObject(topic As %String, ByRef pObj) As %Status
{

        Set result=##Class(%ZEN.Auxiliary.jsonProvider).%WriteJSONStreamFromObject(.tSteamJson,pObj,,,,"aelou")

        Set message=tSteamJson.Read() //TODO CHECK LIMIT STRING

        Set result=..sendMessage(topic,message)

        Quit result
}

ClassMethod isValidJson(message As %String)
{

     try {
            do Do^ZPretty(.message)  //OJO SE REQUIERE ZPretty.mac
            set ok=1
        }catch er
        {
                set ok=0
        }

     //if ok   ;set $TEST
     quit ok
}

}
