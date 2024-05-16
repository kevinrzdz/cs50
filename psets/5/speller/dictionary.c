// Implements a dictionary's functionality

#include <ctype.h>
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <strings.h>

#include "dictionary.h"

// Represents a node in a hash table
typedef struct node
{
  char word[LENGTH + 1];
  struct node *next;
} node;

// TODO: Choose number of buckets in hash table
const unsigned int N = 45;

// Hash table
node *table[N];

int total_words = 0;

// Returns true if word is in dictionary, else false
bool check(const char *word)
{
  int hash_value = hash(word);
  node *i = table[hash_value];
  while (i != NULL)
  {
    if (strcasecmp(word, i->word) == 0)
    {
      return true;
    }
    i = i->next;
  }

  return false;
}

// Hashes word to a number
unsigned int hash(const char *word)
{
  int length = strlen(word);

  if (length > LENGTH)
  {
    length = LENGTH;
  }

  return length - 1;
}

// Loads dictionary into memory, returning true if successful, else false
bool load(const char *dictionary)
{
  FILE *source = fopen(dictionary, "r");
  if (source == NULL)
  {
    return false;
  }

  char word[LENGTH + 1];
  while (fscanf(source, "%45s", word) != EOF)
  {
    node *new_node = malloc(sizeof(node));
    if (new_node == NULL)
    {
      return false;
    }

    strcpy(new_node->word, word);
    int hash_value = hash(word);

    new_node->next = table[hash_value];
    table[hash_value] = new_node;

    total_words++;
  }
  fclose(source);
  return true;
}

// Returns number of words in dictionary if loaded, else 0 if not yet loaded
unsigned int size(void)
{
  return total_words;
}

// Unloads dictionary from memory, returning true if successful, else false
bool unload(void)
{
  for (int i = 0; i < N; i++)
  {
    while (table[i] != NULL)
    {
      node *temp = table[i];
      table[i] = temp->next;
      free(temp);
    }
  }
  return true;
}
