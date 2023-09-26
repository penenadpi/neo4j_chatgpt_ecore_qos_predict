MATCH(n) set n.CC = toFloat(n.CC)
MATCH(n) set n.BsId = toInteger(n.BsId)
MATCH(n) set n.AreaId = toInteger(n.AreaId)
MATCH(n) set n.QoS = toInteger(n.QoS)
MATCH(n) set n.Nusers = toInteger(n.Nusers)
MATCH(n) set n.Season = toInteger(n.Season)

CALL gds.graph.create.cypher(
  'QosPredictGraph',
  'MATCH (q:QosPredict) WHERE q.QoS is NOT NULL RETURN id(q) as id, 
   q.CC as CC,
   q.BsId as BsId,
   q.AreaId as AreaId,
   q.Nusers as Nusers,
   q.Season as Season, 
   q.QoS as Qos',
  'MATCH (s:QosPredict)-[link]->(e:QosPredict)
RETURN ID(link) as link, ID(s) as source, ID(e) as target'
) 



CALL gds.alpha.ml.nodeClassification.train(
'QosPredictGraph', {
  modelName: 'qos_prediction',
  featureProperties:
['CC', 'BsId', 'AreaId', 'Nusers', 'Season'],
  targetProperty: 'Qos',
  randomSeed: 5,
  holdoutFraction: 0.25,
  validationFolds: 10,
  metrics: [ 'ACCURACY'],
  params: [
{ penalty: 0.001 }
]
}) YIELD modelInfo
RETURN
{penalty: modelInfo.bestParameters.penalty} AS winningModel,
 modelInfo.metrics.ACCURACY.outerTrain AS trainGraphScore,
  modelInfo.metrics.ACCURACY.test 
AS testGraphScore