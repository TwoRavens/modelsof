*Complete Model; cluster on vote.
mlogit votocoa i.sex d1 annistu i.classe i.pub i.cluster
margins cluster,predict (outcome(1))
margins cluster,predict (outcome(2))
margins cluster,predict (outcome(3))
margins cluster,predict (outcome(4))
contrast cluster, atequations overall
