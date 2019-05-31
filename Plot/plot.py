import matplotlib.pyplot as plt
import subprocess
import csv
import numpy as np

def process_txt(path, name):
	with open("results"+name+".csv", 'w') as csvfile:
		writer = csv.writer(csvfile, delimiter=',')
		with open(path) as file:
			minimum = None
			maximum = None
			mean = 0
			no = 0
			for line in file:
				if line.startswith("Resolver:"):
					if no != 0:
						mean = mean/no
						writer.writerow([resolver,round(minimum,2),round(mean,2),round(maximum,2)])
						minimum = None
						maximum = None
						mean = 0
						no = 0
					resolver = line.replace("Resolver:","")
					resolver = resolver.replace("\n","")
				else:
					if maximum == None or float(line) > maximum:
						maximum = float(line)
					if minimum == None or float(line) < minimum :
						minimum = float(line)					
					
					mean += float(line)
					no += 1
					
				

	
def process_csv(path):
	with open(path, 'r') as file:
		reader = csv.reader(file)
		resolvers = []
		min_list = []
		avg_list = []
		max_list = []
		for line in reader:
			 resolvers.append(line[0].split(' ', 1)[1])
			 min_list.append(float(line[1]))
			 avg_list.append(float(line[2]))
			 max_list.append(float(line[3]))

	return resolvers,min_list,avg_list,max_list

def autolabel(rects, xpos='center'):
    """
    Attach a text label above each bar in *rects*, displaying its height.

    *xpos* indicates which side to place the text w.r.t. the center of
    the bar. It can be one of the following {'center', 'right', 'left'}.
    """

    ha = {'center': 'center', 'right': 'left', 'left': 'right'}
    offset = {'center': 0, 'right': 1, 'left': -1}

    for rect in rects:
        height = rect.get_height()
        ax.annotate('{}'.format(height),
                    xy=(rect.get_x() + rect.get_width() / 3, height),
                    xytext=(offset[xpos]*3, 3),  # use 3 points offset
                    textcoords="offset points",  # in both directions
                    ha=ha[xpos], va='bottom')


if __name__ == "__main__":
	
	DNS_path = "../NormalDNS/"
	DNSSec_path = "../DNSSEC/"
	DoT_path = "../DoT/"
	DoH_path = "../DoH/"
	process_txt(DoH_path+"Results/resultdotcom.txt", "DoH")
	
	r, minlist, avglist, maxlist = process_csv("resultsDoH.csv")
	rT = tuple(r)
	minT = tuple(minlist)
	avgT = tuple(avglist)
	maxT = tuple(maxlist)

	ind = np.arange(len(avgT))  # the x locations for the groups
	width = 0.3  # the width of the bars

	fig, ax = plt.subplots()
	rects1 = ax.bar(ind - width/3, minT, width/3, label='Min')
	rects2 = ax.bar(ind, avgT, width/3, label='Avg')
	rects3 = ax.bar(ind + width/3, maxT, width/3, label='Max')
	
	ax.set_ylabel('Times')
	ax.set_title('Times for DoHResolvers')
	ax.set_xticks(ind)
	ax.set_ylim(bottom=0)
	ax.set_xticklabels(rT)
	ax.legend()

	autolabel(rects1, "left")
	autolabel(rects2, "center")
	autolabel(rects3, "right")

	fig.tight_layout()

	plt.show()

	# ax = plt.subplot(111)
	# ax.bar([1,2], minlist, width=0.2, color='b', align='center')
	# ax.bar([1,2], avglist, width=0.2, color='g', align='center')
	# ax.bar([1,2], maxlist, width=0.2, color='r', align='center')
	# ax.autoscale(tight=True)
	# plt.show()