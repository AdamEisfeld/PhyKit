//
//  CPHYCollisionShape.m
//  BulletPhysics
//
//  Created by Adam Eisfeld on 2020-06-12.
//  Copyright © 2020 adam. All rights reserved.
//

#import "CPHYCollisionShape.h"
#import "CPHYGeometry.h"
#import "CPHYCollisionShape+Internal.h"
#import "CPHYStructs.h"
#import "CPHYStructs+Internal.h"
#import "CPHYGeometry.h"
#import "CPHYMesh.h"
#import "CPHYPolygon.h"
#import "CPHYVertex.h"
#import "CPHYDependencies+Internal.h"

@interface CPHYCollisionShape() {
    
    NSArray *_collisionShapes;

}

@end

@implementation CPHYCollisionShape

- (instancetype)init {
    self = [super init];
    if (self) {
        _c_shape = new btEmptyShape();
        _transform = PHYMatrix4MakeIdentity();
    }
    return self;
}

- (instancetype)initWithSerializedData: (NSData *)serializedData {
    self = [super init];
    if (self) {

        int bufferSize = int([serializedData length] / sizeof(char));
        char* buffer = (char*) [serializedData bytes];
        btBulletWorldImporter *importer = new btBulletWorldImporter();
        importer->loadFileFromMemory(buffer, bufferSize);
        int numShape = importer->getNumCollisionShapes();
        if (numShape) {
            _c_shape = (btBvhTriangleMeshShape*)importer->getCollisionShapeByIndex(0);
        } else {
            _c_shape = new btEmptyShape();
        }

        _transform = PHYMatrix4MakeIdentity();
    }
    return self;
}

- (instancetype)initSphereWithRadius: (float)radius transform: (struct PHYMatrix4)transform {
    self = [super init];
    if (self) {
        _c_shape = new btSphereShape(radius);
        _transform = transform;
    }
    return self;
}

- (instancetype)initBoxWithWidth: (float)width height: (float)height length: (float)length transform: (struct PHYMatrix4)transform {
    self = [super init];
    if (self) {
        _c_shape = new btBoxShape(btVector3(width / 2.0, height / 2.0, length / 2.0));
        _transform = transform;
    }
    return self;
}

- (instancetype)initCapsuleWithRadius:(float)radius height:(float)height transform:(struct PHYMatrix4)transform {
    self = [super init];
    if (self) {
        _c_shape = new btCapsuleShape(radius, height - (2 * radius));
        _transform = transform;
    }
    return self;
}

- (instancetype)initCylinderWithRadius:(float)radius height:(float)height transform:(struct PHYMatrix4)transform {
    self = [super init];
    if (self) {
        _c_shape = new btCylinderShape(btVector3(radius, height/2, radius));
        _transform = transform;
    }
    return self;
}

- (instancetype)initStaticPlaneWithDirection:(struct PHYVector3)direction transform:(struct PHYMatrix4)transform {
    self = [super init];
    if (self) {
        btVector3 c_direction = btVector3(direction.x, direction.y, direction.z);
        _c_shape = new btStaticPlaneShape(c_direction, 0);
        _transform = transform;
    }
    return self;
}

- (instancetype)initWithBTCollisionShape: (btCollisionShape *)collisionShape transform: (struct PHYMatrix4)transform {
    self = [super init];
    if (self) {
        _c_shape = collisionShape;
        _transform = transform;
    }
    return self;
}
                                      
- (instancetype)initWithCollisionShape:(CPHYCollisionShape *)collisionShape transform:(struct PHYMatrix4)transform {
    return [self initWithCollisionShapes:@[collisionShape] transform:transform];
}

- (instancetype)initWithCollisionShapes: (NSArray <CPHYCollisionShape *>*)collisionShapes transform: (struct PHYMatrix4)transform {
    self = [super init];
    if (self) {
        if (collisionShapes.count > 1) {
            // We need to hold on to these other collision shapes to prevent memory issues
            _collisionShapes = collisionShapes;
            btCompoundShape *c_compoundShape = new btCompoundShape();
            for (CPHYCollisionShape *collisionShape in collisionShapes) {
                btTransform c_transform = btTransformMakeFrom(collisionShape.transform);
                c_compoundShape->addChildShape(c_transform, collisionShape.c_shape);
            }
            _c_shape = c_compoundShape;
        } else {
            CPHYCollisionShape *collisionShape = collisionShapes.firstObject;
            _c_shape = collisionShape.c_shape;
        }

        _transform = transform;
    }
    return self;
}

- (instancetype)initConvexHullWithGeometry: (CPHYGeometry *)geometry transform: (struct PHYMatrix4)transform {
    self = [super init];
    if (self) {

         btCompoundShape *c_compoundShape = new btCompoundShape();
        
         for (CPHYMesh *mesh in geometry.meshs) {
             
             btConvexHullShape *c_convexHull = new btConvexHullShape();
             c_convexHull->setMargin(0.04);
             for (CPHYPolygon *polygon in mesh.polygons) {
                 
                 for (CPHYVertex *vertex in polygon.vertices) {

                     btVector3 c_vertexPosition = btVector3(vertex.position.x, vertex.position.y, vertex.position.z);
                     c_convexHull->addPoint(c_vertexPosition);
                 }

             }
             
             btTransform c_localTransform = btTransform();
             c_localTransform.setIdentity();
             c_compoundShape->addChildShape(c_localTransform, c_convexHull);
             
             
         }
         
        _c_shape = c_compoundShape;
        _transform = transform;
    }
    return self;
}

- (instancetype)initTriangleMeshWithGeometry: (CPHYGeometry *)geometry transform: (struct PHYMatrix4)transform {
    self = [super init];
    if (self) {
        
        btTriangleMesh *c_mesh = new btTriangleMesh();
        
        for (CPHYMesh *mesh in geometry.meshs) {
            
            for (CPHYPolygon *polygon in mesh.polygons) {

                btVector3 c_vertexPosition1 = btVector3(polygon.vertices[0].position.x, polygon.vertices[0].position.y, polygon.vertices[0].position.z);
                btVector3 c_vertexPosition2 = btVector3(polygon.vertices[1].position.x, polygon.vertices[1].position.y, polygon.vertices[1].position.z);
                btVector3 c_vertexPosition3 = btVector3(polygon.vertices[2].position.x, polygon.vertices[2].position.y, polygon.vertices[2].position.z);
                
                c_mesh->addTriangle(c_vertexPosition1, c_vertexPosition2, c_vertexPosition3);

            }
            
        }

        _c_shape = new btBvhTriangleMeshShape(c_mesh, true);
        _transform = transform;
    }
    return self;
}

- (NSData *)serialize {
    
    int maxSerializeBufferSize = 1024*1024*5;
    btDefaultSerializer*    serializer = new btDefaultSerializer(maxSerializeBufferSize);
    serializer->startSerialization();
    _c_shape->serializeSingleShape(serializer);
    serializer->finishSerialization();
    const unsigned char *bufferBytes = serializer->getBufferPointer();
    int bufferSize = serializer->getCurrentBufferSize();
    NSData *data = [NSData dataWithBytes:bufferBytes length:bufferSize];
    return data;
    
}

- (void)setMargin: (float)margin {
    _c_shape->setMargin(margin);
}

- (float)margin {
    return _c_shape->getMargin();
}

- (void)dealloc {
    if (_c_shape != NULL) {
        delete _c_shape;
    }
    _collisionShapes = nil;
}

@end
