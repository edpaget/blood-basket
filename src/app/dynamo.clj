(ns app.dynamo
  (:require [cognitect.aws.client.api :as aws]
            [cognitect.aws.credentials :as credentials]))

(def table-name "blood-basket")

(defn make-client [{:keys [is-localstack?]}]
  (aws/client
   (cond-> {:api :dynamodb}
     is-localstack? (-> (assoc :endpoint-override
                               {:protocol :http
                                :hostname "localhost"
                                :port "4566"})
                        (assoc :region "us-east-1")
                        (assoc :credentials-provider
                               (credentials/basic-credentials-provider
                                {:access-key-id     "ABC"
                                 :secret-access-key "XYZ"}))))))

(defn get-item
  [client pk sk]
  (aws/invoke client {:op :GetItem
                      :request {:TableName table-name
                                :Key {"pk" {:S pk}
                                      "sk" {:S sk}}}}))

(defn put-item
  [client pk sk fields]
  (aws/invoke client {:op :PutItem
                      :request {:TableName table-name
                                :Item (merge {"pk" {:S pk}
                                              "sk" {:S sk}}
                                             fields)}}))
