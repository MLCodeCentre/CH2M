import cv2

def showImage(file):

    img = cv2.imread(file,1)
    img = cv2.resize(img, (0,0), fx=0.25, fy=0.25)
    cv2.imshow('image', img)
    cv2.waitKey(0)
    cv2.destroyAllWindows()

#def orthoganolise():