import cv2
import numpy as np

def extendLine(line, y1_target, y2_target):
   
    x1, y1, x2, y2 = line
    alpha = np.arctan((y1-y2)/(x1-x2 + 0.1))
    
    if y1_target > y1:
    
        r = (y1_target-y1) / np.sin(alpha)
        dx = r * np.cos(alpha)
        x1 = int(x1 + dx)
        y1 = y1_target
                
    if y2_target < y2:

        r = (y2_target-y2) / np.sin(alpha)
        dx = r * np.cos(alpha)
        x2 = int(x2 + dx)
        y2 = y2_target

    return [x1, y1, x2, y2]    
    
        
def cleanLine(line):

    x1, y1, x2, y2 = line
    if y2 > y1:
        line = [x2, y2, x1, y1]
    
    return line

    
def averageLines(lines):
    
    left_lines = []
    right_lines = []
    
    for line in lines:
        x1, y1, x2, y2 = line[0]
        slope = (y1-y2)/(x1-x2)
        
        if slope < 0:
            left_lines.append(line[0])
        else:
            right_lines.append(line[0])
        
    if len(right_lines) == 0:
        right_lines = [[0,0,0,0]]
        
    if len(left_lines) == 0:
        left_lines = [[0,0,0,0]]
    
    left_line = np.mean(left_lines, axis=0)
    left_line = list(left_line)
    left_line = [int(c) for c in left_line]
    
    right_line = np.mean(right_lines, axis=0)
    right_line = list(right_line)    
    right_line = [int(c) for c in right_line]

    return left_line, right_line
        
        
def regionOfInterest(img, height, width):  
    
    c1 = (int(width*0.05), height)
    cv2.circle(img,c1, 5, (0,0,255), -1)
    #print(c1)
    c2 = (int(width*0.95), height)
    #cv2.circle(img,c2, 5, (0,0,255), -1)
    #print(c2)

    theta1 = np.pi/4
    theta2 = np.pi/4
    r = 300

    c3 = (int(c1[0] + r*np.cos(theta1)), int(c1[1] - r*np.sin(theta1))) 
    #cv2.circle(img,c3, 5, (0,0,255), -1)
    cv2.line(img, c1, c3, (0,0,255))
    #print(c3)

    c4 = (int(c2[0] - r*np.cos(theta2)), int(c2[1] - r*np.sin(theta2))) 
    #cv2.circle(img,c4, 5, (0,0,255), -1)
    cv2.line(img, c2, c4, (0,0,255))
    #print(c4)
    #showImage(img)
    
    points = np.array([c1, c2, c4, c3], np.int32)
    return points