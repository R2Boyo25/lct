#!/bin/bash
# NONFUNCTIONAL. USE export_layers from github

if [ "$1" = "--help" ]; then
cat <<EOF
$0 <file.xcf>
   Export all layers of <file.xcf> as separate .png files 
EOF
    
  exit
fi

{
    cat <<EOF
(define (background? layer-ref) (not (equal? (gimp-layer-get-name layer-ref) '("Background"))))

(map gimp-layer-get-name (cdr (filter background? (vector->list (list-ref (gimp-image-get-layers (aref (cadr (gimp-image-list)) 0)) 1)))))
EOF

# (gimp-layer-get-name (list-ref (gimp-image-get-layers (aref (cadr (gimp-image-list)) 0)) 1))
echo "(gimp-quit 0)"
} | gimp -i -b - $1
