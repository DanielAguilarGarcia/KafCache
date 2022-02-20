# KafCache
Proyecto para enviar mensajes a topics de Kafka.


Para configurarlo en Caché importaremos el paquete Kafka y abriremos la clase Kafka.Helper.cls
Dentro de la misma configuraremos los parámetros de configuración del Gateway que ejecuta la DLL

![image](https://user-images.githubusercontent.com/28974107/154824995-6beb46e7-292d-48cd-b6ce-95cb686875ec.png)


Una vez configurado ejecutamos por terminal el metodo install:

Do ##class(Kafka.Helper).install()

Crear topics:

New topic,server,keyId
Set topic = "mitopic"
Set server = "ipServerKafka:puertoEscucha"
Set keyId = "miKey" Do ##class(Kafka.Helper).createTopic(topic,server,keyId)


Los topics creados se graban el el global ^KAFKA

La estructura del mismo es ^KAFA("TOPICS", nombreTopicX)

                            ^KAFA("TOPICS", nombreTopicX,"keyId") = clave Id enviado junto los mensajes

                            ^KAFA("TOPICS", nombreTopicX,"server") = ip kafka : puerto escucha 
         

Opción 1 Enviar texto en formato JSON:

Set topic="mitopic"
Set message="{""Valor"":""hola""}" 
Set res=##class(Kafka.Producer).sendMessage(topic,message)



Opción 2 Enviar objeto %ZEN.proxyObject

Set topic="mitopic" 

Set message=##class(%ZEN.proxyObject).%New()
Set message.nombre="Dani"
Set message.direccion="C/Falsa, 123" 

Set res=##class(Kafka.Producer).sendObject(topic, .message)

