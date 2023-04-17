#!/usr/bin/env bash


# Delete GitOps
oc delete gitopsservice cluster --ignore-not-found

# Delete Pipelines
oc delete tektonconfig --all --all-namespaces --ignore-not-found
oc delete $(oc get crd -o=custom-columns=NAME:.metadata.name --no-headers | grep tekton.dev | awk '{printf "%s%s",sep,$0; sep=","}') --ignore-not-found --all --all-namespaces

# Delete Subscriptions
oc delete sub openshift-gitops-operator -n openshift-operators --ignore-not-found
oc delete sub openshift-pipelines-operator-rh -n openshift-operators --ignore-not-found

# Delete Versions
oc delete csv $(oc get csv -o=custom-columns=NAME:.metadata.name --no-headers | grep -e gitops | awk '{printf "%s%s",sep,$0; sep=","}') --ignore-not-found -n openshift-operators 
oc delete csv $(oc get csv -o=custom-columns=NAME:.metadata.name --no-headers | grep -e pipelines | awk '{printf "%s%s",sep,$0; sep=","}') --ignore-not-found -n openshift-operators

# Delete Projects
oc delete project openshift-gitops openshift-pipelines --ignore-not-found
oc delete project cicd dev --ignore-not-found

# Let everything quiet down on the server
sleep 180

echo "Done!"